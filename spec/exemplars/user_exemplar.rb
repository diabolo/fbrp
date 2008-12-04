class User < ActiveRecord::Base

  generator_for :login, :start => 'login-1' do |prev|
    name, number = prev.split('-')
    name + '-' + (number_to_i + 1)
  end
  
  generator_for :email, :start => 'test@domain.com' do |prev|
    user, domain = prev.split('@')
    user.succ + '@' + domain
  end

  generator_for :name, :start => 'Fred Bloggs' do |prev|
    first, last = prev.split(' ')
    first.succ + ' ' + last.succ
  end

  generator_for :password, :start => 'testxvcdg1' do |prev|
    prev.succ    
  end

  generator_for :password_confirmation, :start => 'testxvcdg1' do |prev|
    prev.succ    
  end
  
end
