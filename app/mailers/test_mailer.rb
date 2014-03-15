class TestMailer < ActionMailer::Base
  default from: "results@medsafelabs.com"
  layout 'mailer'
  
  def results_available(test)
    @test = test
    mail(to: test.user.email, subject: "Results from MedSafeLabs available")  
  end
  
end
