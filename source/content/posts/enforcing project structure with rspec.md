---
title: "Enforcing Project Structure With Rspec"
date: 2018-02-09T23:14:27+01:00
---

I faced a situation where I'm working on a legacy project, that project was a
normal ruby on rails project, with controllers, models, decorators, concerns,
but with the long life of the project and turnover of the developers,
inconsistency was introduced everywhere.

One of the places where consistency were violated was the concerns directories,
where concerns names were not the same, some of them are suffixed with `Concern`
suffix, and others were not.

That refactoring was pretty simple on it's own, you only need to rename,
concerns files to the proper naming, rename the concerns modules themselves, and
also any usage for these modules.

The problem is that we don't just want to have that naming convention for the
current concerns but we also need to inforce it for any future concerns, so
we're trying to make it impossible to break that rule again.

My approach is using the usual testing framework in place, as we use Rspec I
just added a test suit for `ActiveSupport::Concern` where I get all concerns
files and make sure all of them are meeting the criteria.

And the following code snippet is the final result

```ruby
Rspec.describe ActiveSupport::Concern do
  files_paths = Rails.root.join('app', 'controllers', 'concerns', '**', '*.rb')
  files = Dir.glob(files_paths)

  files.each do |file|
    describe file do
      it "must end with concern" do
        expect(file).to end_with('_concern.rb')
      end
    end
  end
end
```

this snippet will get all ruby files in `app/controllers/concerns` and make sure
all of them meets the naming convention.

The same technique could be applied to `app/decorators` if you're using Drapper
gem and want to make sure the naming is not violated, or the inheritance is
maintained for all decorators.

it can be applied to basically any rule you need to keep in your project
lifetime.

That doesn't just prevent people from breaking the design decision you took for
that project, but it's also for you as over time you'll forget the decisions
you've made and that's a safety net for you.

along with that technique I also document the rules I decided for each directory
in the project in a `README.md` file inside the corresponding directory, and I
link to it from the root `README.md` file, that makes it mode visible for
contributors.
