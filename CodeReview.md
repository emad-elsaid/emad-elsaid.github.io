Check list for code review 

# Basic checks

- [ ] Does it work?
- [ ] Does it fullfill all functional and non functional requirements?
- [ ] Does it consider edge cases?
- [ ] Is it protected against incorrect input?

# Size 

- [ ]  PR not too big
- [ ]  Solves one problem

# Links

- [ ] Links to a ticket or design document

# Refactoring

- [ ] Does it change existing user API/interface
  - does it return different results
  - does it change input or types

# Dependencies

- [ ] Does it add dependency?
  - [ ] is it really needed/how much of it is needed?
  - [ ] is it reviewed for license?
  - [ ] is it reviewed for security?

# Database

- [ ] Make sure queries use proper indexes
- [ ] Review any migration with [strong migrations guidelines](https://github.com/ankane/strong_migrations)

# Non functional

- [ ] Problem description
- [ ] Solution description

# New Feature

- [ ] Consider scalability
- [ ] Consider effeciency
- [ ] Monitored for success and failures
- [ ] Alerts setup for SLA failure

# Inform

- [ ] Inform any downstream team
- [ ] Inform any technical stakeholder
- [ ] Technical documentation updated

# References

- [Gitlab Code review](https://about.gitlab.com/handbook/engineering/workflow/code-review/)
- [Gitlab Code review guidelines](https://docs.gitlab.com/ee/development/code_review.html)