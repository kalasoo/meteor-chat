Meteor.publish 'users', () ->
  Meteor.users.find {}, {fields: {emails: 1, profile: 1}}

Meteor.publish 'comments', () ->
  Comments.find {}, {sort: {created_at: -1}, limit: 20}

Meteor.publish 'allComments', () ->
  Comments.find()