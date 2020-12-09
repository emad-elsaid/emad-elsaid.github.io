---
title: Explain all SQL statements in rails
---

I needed to see all plans for the executed SQL statements in my rails project
while in development. so I found this [Gem
repository](https://github.com/yhirano55/activerecord-explainer) and I thought I
want to understand how this works, and found that the main piece of code is in
[this
file](https://github.com/yhirano55/activerecord-explainer/blob/28050ae300032746258daafe99efacacc584f817/lib/activerecord/explainer/subscriber.rb)
so I tried to get this code and simplify it and add it to an initializer and the
result is the following stripped down version

```ruby
class Explainer < ActiveSupport::LogSubscriber
  def sql(event)
    payload = event.payload
    return if ignore_payload?(payload)

    debug color(ActiveRecord::Base.connection.explain(payload[:sql], payload[:binds]), :yellow)
  end

  private

  IGNORED_PAYLOADS = %w[SCHEMA EXPLAIN].freeze
  EXPLAINED_SQLS = /\A\s*(with|select|update|delete|insert)\b/i.freeze

  def ignore_payload?(payload)
    payload[:cached] ||
      IGNORED_PAYLOADS.include?(payload[:name]) ||
      payload[:sql] !~ EXPLAINED_SQLS
  end
end

Explainer.attach_to :active_record
```

Just make sure you don't commit this code or put a condition at the last line to
work only in development.
