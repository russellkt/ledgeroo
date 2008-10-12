desc "Configure Subversion for Rails" 
task :configure_for_svn do 
  system "svn remove log/*" 
  system "svn commit -m 'removing all log files from subversion'" 
  system 'svn propset svn:ignore "*.log" log/' 
  system "svn update log/" 
  system "svn commit -m 'Ignoring all files in /log/ ending in .log'" 
  system 'svn propset svn:ignore "*.db" db/' 
  system "svn update db/" 
  system "svn commit -m 'Ignoring all files in /db/ ending in .db'" 
  system "svn move config/database.yml config/database.example" 
  system "svn commit -m 'Moving database.yml to database.example to provide a template for anyone who checks out the code'" 
  system 'svn propset svn:ignore "database.yml" config/' 
  system "svn update config/" 
  system "svn commit -m 'Ignoring database.yml'" 
  system "svn remove tmp/*" 
  system "svn commit -m 'Removing /tmp/ folder'" 
  system 'svn propset svn:ignore "*" tmp/' 
end 

task :ignore_development_env do
  system "svn move config/environments/development.rb config/environments/development_example" 
  system "svn commit -m 'Moving development.rb from environments to example file'" 
  system 'svn propset svn:ignore "development.rb" config/environments/' 
  system "svn update config/"
end

task :ignore_attachments do 
  system "svn rm public/attachments/* --force"
  system "svn commit -m'removing attachments'"
  system "svn propset svn:ingore '*' public/attachments/ "
  system "svn update"
end
desc "Add new files to subversion" 
task :add_new_files do 
  system "svn status | grep '^\?' | sed -e 's/? *//' | sed -e 's/ /\ /g' | xargs svn add" 
end 

desc "shortcut for adding new files" 
task :add => [ :add_new_files ]
