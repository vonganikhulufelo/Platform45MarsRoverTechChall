## Tools and softwares
* ruby 2.7.5
* Rails 7.0.2


## Preparing application to start
1. Clone or download repository.
2. Run `bundle install`
3. Run `rake  db:create`  
4. Run `rake  db:migrate`
5. Run `rails s`
6. Go to `http://localhost:3000/positions`

## Comment

I decided to make a Model because I couldn't maintain track of my last position after submitting the form because the page would refresh and I would lose previous positions.
