#!/usr/bin/env ruby
require "optparse" 
require 'rexml/document' 
require "xmlrpc/client" 
require 'uri' 
require 'ostruct' 
require 'nokogiri' 

class OptParser
    def self.parse(args)
      options = OpenStruct.new
      options.endpoint_hostname = "localhost"
      options.endpoint_port = 2633
      options.endpoint_path = "/RPC2"
      options.vm_state = 3
      options.list_ip = false
      options.list_id = false
      options.list_name = false
      options.verify_ssl = true
      
      opt_parser = OptionParser.new do |opts|
        opts.banner = "Usage: list_vms.rb [options]"
        opts.separator ""
        opts.separator "Mandatory arguments:"
        opts.on("--credentials username:password",
                "User credentials in format: username:password.") do |cred|
          options.credentials = cred
        end
        opts.separator ""
        opts.separator "Optional:"
        opts.on('--list-id',
                "Add the IDs of the VMs to the output.") do |list_id|
          options.list_id = true
        end
        opts.on('--list-ip',
                "Add the IDs of the VMs to the output.") do |list_ip|
          options.list_ip = true
        end
        opts.on('--list-name',
                "Add the names of the VMs to the output.") do |list_name|
          options.list_name = true
        end
        opts.on('--state N', Integer,
                "If set, lists only the VMs in the specified state. Default: 3. State can be any of these: 
https://docs.opennebula.org/5.4/operation/references/vm_states.html#list-of-states") do |n|
          options.vm_state = n
        end
        opts.on("--hostname example.com",
                "Hostname of the OpenNebula endpoint. Default: localhost") do |host|
          options.endpoint_hostname = host
        end
        opts.on("--port 2633", Integer,
                "Port number of the OpenNebula endpoint. Default: 1") do |port|
          options.endpoint_port = port
        end
        
        opts.on('--path "/RPC2"',
                "RPC path of the OpenNebula endpoint. Default: /RPC2") do |path|
          options.endpoint_path = path
        end
        
        opts.on('--no-ssl-verify"',
                "Disable SSL certificate verificaion.") do |v|
          options.verify_ssl = false
        end
        opts.separator ""
        opts.separator "Common options:"
        opts.on_tail("-h", "--help", "Show this message") do
          puts opts
          exit
        end
      end
      opt_parser.parse!(args)
      options
    end 
end 

ARGV << '-h' if ARGV.empty? 
begin
  options = OptParser.parse(ARGV)
  mandatory = [:credentials]
  missing = mandatory.select{ |param| options[param].nil? }
  unless missing.empty?
    raise OptionParser::MissingArgument.new(missing.join(', '))
  end
 rescue OptionParser::InvalidOption, OptionParser::MissingArgument
  puts $!.to_s
  puts
  puts OptParser.parse %w[--help]
  exit 
end 
connection_args = {
              :host => options.endpoint_hostname, 
              :port => options.endpoint_port, 
              :use_ssl => true, 
              :path => options.endpoint_path
            }
client = XMLRPC::Client.new_from_hash(connection_args) 
if !options.verify_ssl then
  client.http.verify_mode = OpenSSL::SSL::VERIFY_NONE end 
begin
     response = client.call("one.vmpool.info", options.credentials, -1, -1, -1, Integer(options.vm_state)) 
rescue XMLRPC::FaultException => e
     puts "Error:"
     puts e.faultCode
     puts e.faultString
     exit -1 
end 
doc = Nokogiri::XML.parse(response[1]) 
vms = doc.xpath("//VM//ID") 

vms.each do |vm|
  output = ""
  if !options.list_id && !options.list_ip && !options.list_name then
    options.list_id = true
    options.list_ip = true
    options.list_name = true
  end
  if options.list_id then
    output += doc.xpath("//VM[ID='#{vm.text}']/ID").text + " "
  end
  if options.list_ip then
    output += doc.xpath("//VM[ID='#{vm.text}']//TEMPLATE//NIC//IP").text + " "
  end
  if options.list_name then
    output += doc.xpath("//VM[ID='#{vm.text}']//NAME").text
  end
  puts output.rstrip
 end
