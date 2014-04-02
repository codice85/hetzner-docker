#!/usr/bin/env ruby


require "slop"
require "hetzner-docker"
DEFAULT_IDENTITY_FILE = '~/.ssh/id_rsa.pub'
opts = Slop.parse(help: true) do
  description 'Usage: manage.rb [command] [options]'
  on 'v','version', 'module version' do
    puts HetznerDocker::VERSION
  end

  on 'm','methods', 'print all methods' do
    puts HetznerDocker.public_instance_methods
  end


  command 'rescue' do
    description 'Enter Rescue mode'
    on :i, :ip=, 'Server ip'
    run do |opts, args|
      host = HetznerHost.new(opts.to_hash)
      host.rescuemode
    end

  end

  command 'ubuntu' do
    description 'Install ubuntu on server'
    on :i, :ip=, 'Server ip'
    on :H, :hostname=, 'Desired server hostname', argument: :optional
    on :d, :domain=, 'Desired server domain', argument: :optional
    run do |opts, args|
      host = HetznerHost.new(opts.to_hash)
      host.rescuemode
      host.install_ubuntu
    end
  end

  command 'chef' do
    on :i, :ip=, 'Server ip'
    on :bootstrap_version=, 'Chef version to install'
    description 'Install chef'
    run do |opts, args|
      host = HetznerHost.new(opts.to_hash)
      host.bootstrap_chef
    end
  end

  command 'cook' do
    description 'Cook docker recipes'
    on :i, :ip=, 'Server ip'
    on :b, :cookbook= , 'Cook this recipe only', argument: :optional
    run do |opts, args|
      host = HetznerHost.new(opts.to_hash)
      host.run_chef
    end
  end

  command 'bootstrap' do
    description 'Do everything'
    on :i, :ip=, 'Server ip'
    on :H, :hostname=, 'Desired server hostname', argument: :optional
    on :d, :domain=, 'Desired server domain', argument: :optional
    on :b, :cookbook= , 'Cook this recipe only', argument: :optional
    on :bootstrap_version=, 'Chef version to install'
    run do |opts, args|
      host = HetznerHost.new(opts.to_hash)
      host.rescuemode
      host.install_ubuntu
      host.bootstrap_chef
      host.run_chef
    end
  end
end