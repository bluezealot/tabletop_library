class PublishersController < ApplicationController
    # GET /publishers
    # GET /publishers.json
    def index
        @publishers = Publisher.all
    end
end
