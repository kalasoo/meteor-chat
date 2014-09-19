Meteor.publish 'users', () ->
  Meteor.users.find {}, {fields: {emails: 1, profile: 1}}

Meteor.publish 'comments', () ->
  Comments.find()