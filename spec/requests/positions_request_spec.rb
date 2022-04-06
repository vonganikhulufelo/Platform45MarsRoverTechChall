require 'rails_helper'

RSpec.describe "Positions", type: :request do

  describe "Get #index" do
        it "Start " do
            get "/commands"
            expect(response).to be_successful
        end
    end

    describe "Post #create" do
        it "Test with empty inputs" do
            post "/commands", :params => {:position => {:x => '',:y => '',:direction => ''}}
            follow_redirect!
            expect(response.body).to include("Rover position cannot be empty or contain any negative number and the position must be N S W or E.")
        end


        it "Checks if the positon is valid" do
            post "/commands", :params => {:position => {:x => 5,:y => 5,:direction => ''}}
            follow_redirect!
            expect(response.body).to include("Rover position cannot be empty or contain any negative number and the position must be N S W or E.")
        end

        it "Checks negative inputs" do
            post "/commands", :params => {:position => {:x => -5,:y => -5,:direction => 'E'}}
            follow_redirect!
            expect(response.body).to include("Rover position cannot contain any negative number")
        end

        it "Creates starting position" do
            post "/commands", :params => {:position => {:x => 1,:y => 2,:direction => 'N'}}
            follow_redirect!
            expect(response.body).to include("Successful created starting position")
        end
        it "Starting position must be created before make the rover spin" do
            post "/commands", :params => {:position => {:x => '',:y => '',:direction => 'LMLMLMLMM'}}
            follow_redirect!
            expect(response.body).to include("Must atleast have starting position")
        end
        it "Spin with initial position" do
            Command.create!(point_x:  1, point_y:  2, direction: 'N')
            post "/commands", :params => {:command => {:x => '',:y => '',:direction => 'LMLMLMLMM'}}
            follow_redirect!
            expect(response.body).to include("Successful spined or moved")
        end
    end

end
