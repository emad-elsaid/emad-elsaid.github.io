![](/public/IMG_20210918_153552.webp)

#p2p 

It's common knowledge that most startups fail. With every startup that fails there an application that's now obsolete. you can't open it or use it. The company behind it doesn't exist anymore.

All the effort of the teams behind it from research, design, development and maintenance that got this application to this point is now a wasted effort. It's a very hard moment when you know that years of your life that you spent working on a product didn't result in something useful to other people.

On the other hand there are projects that are surviving longer than any startup product. Like all the open source applications (Inkscape, gimp, gnome projects, KDE projects, IRC clients, Text Editors..etc) if the teams behind these projects disappeared tomorrow morning their projects will continue to run. IRC clients will use other servers in case of one network failed. image editing applications will continue to open files. everything will continue to work and I believe there is something for startups to learn from these projects.

# Let the user choose

For every feature the product team designs there are couple decisions that are made on behalf of the user:

- Social networks develop methods to rank content and filter it for each user
- Food delivery application will keep a central catalog for all restaurants
- Shopping applications has central API for reviews
- Most Web2 applications choose one API for comments source
- Operating system companies restrict the user to use one App store

The problem with the previous features design is that the choice is made for the user and can't be overridden by the user. That ties the feature to one source. One company that deliver the feature. so when this company closes its doors one morning this feature is now useless.

Instead these features can be design in a way similar to the open source applications I mentioned.

# Let others add more solutions

Lets take one example:
- You're designing a rating system so your application will allow rating a product and display the rating
- So there is an API your application will use to do these two operations
- Your application will use a hard coded URL for this API

Instead your feature can be more open as follows:
- Instead of using one API you can have a list of APIs that offer this interface
- The API interface description is published to the public
- Your application will have the list of APIs in the settings page and let the user add/remove APIs that offer this feature
- The user can choose the default API provider from the list
- In the UI the user can switch between different rating providers


- This means you can have this feature offered by other developers when your server is down at some point.
- when your API is down you can fallback to another provider
- When your startup fails the feature can be still used by the community

This applies to other features too like Commenting, food restaurant catalogs. phone numbers sources. operating systems App stores...etc

# Distributing Authority

There are couple features that's always offered by the startup itself:
- Content moderation
- Blocking spammers/abusers

These features puts alot of stress on the company and requires manual intervention most of the time. which means the company effort and spending has to scale with the amount of content on it.

This model isn't stable and to be more distributed. including the users themselves in the process will make the community of your product self sustainable.

Take for example the problem of blocking spammers. Instead of having a team to do that for the whole product users you can let users block spammers for themselves and optionally give the user the ability the share and follow block lists. In this case I can resort to an active user to filter the content for me. children can use their parents lists. and people will group and help each other making the product better. that removes the burden of filtering users from your product team.

Combining this feature by the previous point you get a feature that's independent of the startup in case of failure.

Distributing authoritative features is the key for distributed applications. as the users using each other efforts on the application you can have an application that's totally independent of the company behind it. this opens the door for creativity and expansion.

Imagine if your Facebook messenger can add more content types from other providers so you can send a 3d model with your friends and it gets rendered in the message. or having a nicer voice messages that can be combined with songs musing and change the voice properties. all of these possibilities are locked behind the fact that the company is making the feature development their solve right blocking their user from extending it themselves.

# A step towards distributed applications

This proposed design for features can evolve in the future. So instead of using HTTPS to communicate with the external APIs, applications can use other protocols and networks to pull/push content like a blockchain network, a local peer 2 peer data exchange. Allowing applications to work fully independent of the startup infrastructure freeing the startup from all infrastructure costs over time.

In my mind this approach will give us applications that outlive their developers and startups. and the freedom of the user choice and where to push his data.
