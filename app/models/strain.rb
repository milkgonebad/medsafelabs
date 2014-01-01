class Strain < ActiveRecord::Base
  
  #FIXME - this needs to given it's own resource/ui for maintenance

  def self.all
    ['Blue Monday', 'True Faith', 'Regret', 'Bizarre Love Triangle']
  end
  
end