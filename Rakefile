$LOAD_PATH.push('lib')

require 'cloudrim'

namespace :docker do
  desc 'Login'
  task :login do |t, args|
    system("$(aws ecr get-login --no-include-email)")
  end

  desc 'Build a docker image.'
  task :build, :package_name, :version, :docker_file do |t, args|
    docker_file = args[:docker_file] || 'Dockerfile'
    cmd_build = "docker build -t #{args[:package_name]}:#{args[:version]} -f #{docker_file} ."
    LOG.debug("CMD(build): #{cmd_build}")
    system(cmd_build)
  end

  desc 'Tag a build'
  task :tag, :package_name, :version, :tag do |t, args|
    tag = args[:tag] ||= 'latest'
    version = args[:version]

    cmd_tag_local = format('docker tag %s:%s %s:%s',
                           args[:package_name], args[:version], args[:package_name], tag)

    cmd_tag_ecr_version = format('docker tag %s:%s %s.dkr.ecr.%s.amazonaws.com/%s:%s',
                                 args[:package_name], args[:version], ENV['AWS_ACCOUNT_ID'],
                                 ENV['AWS_REGION'], args[:package_name], version)

    cmd_tag_ecr_tag = format('docker tag %s:%s %s.dkr.ecr.%s.amazonaws.com/%s:%s',
                             args[:package_name], args[:version], ENV['AWS_ACCOUNT_ID'],
                             ENV['AWS_REGION'], args[:package_name], tag)

    LOG.debug(format('CMD(tag_local): %s', cmd_tag_local))
    LOG.debug(format('CMD(tag_ecr_tag): %s', cmd_tag_ecr_tag))
    LOG.debug(format('CMD(tag_ecr_version): %s', cmd_tag_ecr_version))
    system(cmd_tag_local)
    system(cmd_tag_ecr_tag)
    system(cmd_tag_ecr_version)
  end

  desc 'Push a docker image to ECR'
  task :push, :package_name, :version, :tag do |t, args|
    tag = args[:tag] ||= 'latest'
    version = args[:version]

    cmd_push_tag = format('docker push %s.dkr.ecr.%s.amazonaws.com/%s:%s',
                          ENV['AWS_ACCOUNT_ID'], ENV['AWS_REGION'], args[:package_name], version)
    cmd_push_version = format('docker push %s.dkr.ecr.%s.amazonaws.com/%s:%s',
                              ENV['AWS_ACCOUNT_ID'], ENV['AWS_REGION'], args[:package_name], tag)

    LOG.debug(format('CMD(push_tag): %s', cmd_push_tag))
    LOG.debug(format('CMD(push_version): %s', cmd_push_version))

    system(cmd_push_tag)
    system(cmd_push_version)
  end
end

desc 'Do all of the docker things.'
task :docker_web do
  Rake::Task['docker:build'].invoke('cloudrim-web', Cloudrim::VERSION )
  Rake::Task['docker:tag'].invoke('cloudrim-web', Cloudrim::VERSION )
  Rake::Task['docker:push'].invoke('cloudrim-web', Cloudrim::VERSION )
end

desc 'Do all of the docker things for battle engine'
task :docker_battle do
  docker_file = 'Dockerfile.battle'
  Rake::Task['docker:build'].invoke('cloudrim-battle', Cloudrim::VERSION, docker_file )
  Rake::Task['docker:tag'].invoke('cloudrim-battle', Cloudrim::VERSION)
  Rake::Task['docker:push'].invoke('cloudrim-battle', Cloudrim::VERSION)
end