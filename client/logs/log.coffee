Template.logs.commentsCount = () ->
  Comments.find().count()

Template.logs.usersCount = () ->
  commentOwners = Comments.find({}, {fields: {owner: 1}}).map (comment) -> comment.owner
  _.uniq(commentOwners).length
  
  
  
Template.logs.signedUpUsersCount = () ->
  Meteor.users.find().count()