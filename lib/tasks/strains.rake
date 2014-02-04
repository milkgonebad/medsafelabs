namespace :strains do
  desc "Populate the strains table"
  task :initialize => :environment do
    File.open("lib/strains.txt", "r") do |infile|
      while (line = infile.gets)
        puts line.chomp
        Strain.create(name: line)
      end
    end
  end
  
  desc "Prepopulate all exising tests with a strain"
  task :populate_tests => :environment do
    Test.all.each do |t|
      begin
        t.update_attribute(:strain_id, Strain.first.id)
      rescue
        puts "This one failed for some reason:  " << t.inspect
      end  
    end
  end
  
end