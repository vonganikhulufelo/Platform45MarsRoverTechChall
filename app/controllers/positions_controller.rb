class PositionsController < ApplicationController
  @@valid_directions = 'NSEW'
  
    @@north_direction = 'N'
    @@south_direction = 'S'
    @@east_direction = 'E'
    @@west_direction = 'W'
  
    @@valid_commands = 'LRM'
  
    @@left_command = 'L'
    @@right_command = 'R'
    @@move_command = 'M'
    

    def index
      Position.destroy_all
    end

    def create
      if(params[:position][:direction] != '' )

        if(@@valid_directions.index(params[:position][:direction].upcase))
          if((params[:position][:x].to_i >= 0 && (params[:position][:x] != '')) && (params[:position][:y].to_i >= 0 && (params[:position][:y] != '')))
            @direction = params[:position][:direction].upcase
            @ptX = params[:position][:x].to_i
            @ptY = params[:position][:y].to_i
            @final = 0
    
            new_position()
            redirect_to position_path('process'), notice: 'Successful created starting position'
          else
            redirect_to position_path('process'), notice: 'Rover position cannot contain any negative number'
          end
        else
          last_position()
          @temp_command = ''
          @final = 1
          @negative_bounds = 0
          params[:position][:direction].split(//) do | i|
            if(@@valid_commands.index(i))
              @temp_command = @temp_command.to_s + i
            end
          end
          
          if(@temp_command == params[:position][:direction])
            params[:position][:direction].split(//) do | i|
              do_command(i.upcase)
            end
            
            
            if (Position.last)
              if(@negative_bounds == 1)
                redirect_to position_path('process'), notice: 'Negative bounds'
              else
                new_position()
                redirect_to position_path('process'), notice: 'Successful spined or moved'
              end
            else
              redirect_to position_path('process'), notice: 'Must atleast have starting position'
            end
          else
            redirect_to position_path('process'), notice: 'Position letter(s) must contain L or R or M only.'
          end
        end
      else
          redirect_to position_path('process'), notice: 'Rover position cannot be empty or contain any negative number and the position must be N S W or E.'
      end
    end

    def show
        @positions = Position.where(final: 1)
    end
  private
  def do_move
    if (@direction == @@north_direction)
      @ptY = @ptY + 1
    elsif (@direction == @@east_direction)
      @ptX = @ptX + 1
    elsif (@direction == @@south_direction)
      @ptY = @ptY - 1
    elsif (@direction == @@west_direction)
      @ptX = @ptX - 1
    end
    if (@ptX.to_i < 0 || @ptY.to_i < 0)
      @negative_bounds = 1
    end
  end
  
  def do_spin(d)
    @direction = ( (@@valid_directions.index(d)) or (@@valid_commands.index(d)) ) ? d : @direction
  end
  
  def do_command(c)
    if (c == @@left_command)
      if (@direction == @@north_direction)
        do_spin(@@west_direction)
      elsif (@direction == @@west_direction)
        do_spin(@@south_direction)
      elsif (@direction == @@south_direction)
        do_spin(@@east_direction)
      elsif (@direction == @@east_direction)
        do_spin(@@north_direction)
      end
    else
      if (c == @@right_command)
        if (@direction == @@north_direction)
          do_spin(@@east_direction)
        elsif (@direction == @@east_direction)
          do_spin(@@south_direction)
        elsif (@direction == @@south_direction)
          do_spin(@@west_direction)
        elsif (@direction == @@west_direction)
          do_spin(@@north_direction)
        end
      elsif (c == @@move_command)
        do_move
      end
    end
  end

  def last_position()
    @position = Position.last
    if @position
      @ptX = @position.point_x
      @ptY = @position.point_y
      @direction = @position.direction
    end
  end

  def new_position()
    Position.create!(point_x:  @ptX, point_y:  @ptY, direction: @direction,final: @final)
  end
end
