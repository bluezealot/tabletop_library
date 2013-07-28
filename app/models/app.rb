class App < ActiveRecord::Base
  attr_accessible :state
  
  validates :state, presence: true
  validates :state, inclusion: { in: [APP_STATES[:Setup], APP_STATES[:Active], APP_STATES[:Teardown]] }
  
end
