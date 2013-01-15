class PublishersController < ApplicationController
    before_filter :signed_in_user, only: [:index]
    
    def index
        @publishers = Publisher.all
    end
end
