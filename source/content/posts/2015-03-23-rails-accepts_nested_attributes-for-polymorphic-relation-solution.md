---
title: "Rails Accepts_nested_attributes for polymorphic relation solution"
date: 2015-03-23T11:53:44+02:00
---
yesterday i faced a problem with my rails application, my models was as follows

```ruby
class Vehicle < ActiveRecord::Base
  MOVABLES = [:car, :bus, :plane]
  belongs_to :movable, polymorphic: true, dependent: :destroy, required: true, autosave: true
  accepts_nested_attributes_for :movable
end
```

```ruby
class Car < ActiveRecord::Base
  has_one :vehicle, dependent: :destroy, as: :movable
end
```

```ruby
class Bus < ActiveRecord::Base
  has_one :vehicle, dependent: :destroy, as: :movable
end
```

```ruby
class Plane < ActiveRecord::Base
  has_one :vehicle, dependent: :destroy, as: :movable
end
```

so, when i try to create a Veihcle with nested attributes for the `movable` it complain
with error "are you trying to build a polymorphic relation?" and i thought it will continue
my code was as follows

```ruby
Veihcle.create! name: 'my car', movable_type: 'Car', movable_attributes: { color: red }
```

the previous code should create a Veihcle with extended attributes of a car with color = red,
so i had to google first and guess what is the first thing to find?, Yup it is [Stackoverflow](http://http://stackoverflow.com/questions/3969025/accepts-nested-attributes-for-with-belongs-to-polymorphic)

the highly rated solution didn't work for me :
```ruby
class Job <ActiveRecord::Base
  belongs_to :client, :polymorphic=>:true
  attr_accessible :client_attributes
  accepts_nested_attributes_for :client

  def attributes=(attributes = {})
    self.client_type = attributes[:client_type]
    super
  end

  def client_attributes=(attributes)
    some_client = self.client_type.constantize.find_or_initilize_by_id(self.client_id)
    some_client.attributes = attributes
    self.client = some_client
  end
end
```

so i tried this solution

```ruby
class Job <ActiveRecord::Base
  belongs_to :client, :polymorphic=>:true, :autosave=>true
  accepts_nested_attributes_for :client

  def attributes=(attributes = {})
    self.client_type = attributes[:client_type]
    super
  end

  def client_attributes=(attributes)
    self.client = eval(type).find_or_initialize_by_id(attributes.delete(:client_id)) if client_type.valid?
  end
end
```

and i had to modify it to suite my code like so

```ruby
class Vehicle < ActiveRecord::Base
  MOVABLES = [:car, :bus, :plane]
  belongs_to :movable, polymorphic: true, dependent: :destroy, required: true, autosave: true
  accepts_nested_attributes_for :movable

  def attributes=(attributes = {})
    self.movable_type = attributes[:movable_type]
    super
  end

  def movable_attributes=(attributes)
    self.movable = eval(type).find_or_initialize_by_id(attributes.delete(:movable_id)) if movable_type.valid?
  end
end
```

but yeah, that didn't work either so i got the idea from the previous code `movable_attributes=` is the method that is invoked
when assigning the the mobable_attributes hash, so i have to override it to create/update the current child as follows

```ruby
class Vehicle < ActiveRecord::Base
  MOVABLES = [:car, :bus, :plane]
  belongs_to :movable, polymorphic: true, dependent: :destroy, required: true, autosave: true
  accepts_nested_attributes_for :movable

  def movable_attributes=(attributes)
    if MOVABLES.include?(movable_type.underscore.to_sym)
      self.movable ||= self.movable_type.constantize.new
      self.movable.assign_attributes(attributes)
    end
  end
end
```

that will create a movable object if it doesn't exist, and it'll update it in case it
already exists.

i wish rails would behave like this by default, and i have no idea why it doesn't do that as it is
a trivial solution.
