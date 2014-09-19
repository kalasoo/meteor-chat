# 
# Comment Model
# 
#   owner: user id
#   content: comment content
#   created_at: time
#   updated_at: time

@Comments = new Mongo.Collection 'comments'

@Comments.allow
  insert: (userId, comment) ->
    return false
  update: (userId, comment, fields, modifier) ->
    userId is comment.owner and ! _.difference(fields, ['content', 'updated_at']).length
  remove: (userId, comment) ->
    userId is comment.owner

NonEmptyString = Match.Where (x) ->
  check x, String
  x.length isnt 0

Meteor.methods
  createComment: (content) ->
    check content, NonEmptyString
    if not @userId
      throw new Meteor.Error(403, "You must be logged in")
    commentId = Random.id()
    timeNow = Date.now()
    Comments.insert
      _id: commentId
      owner: @userId
      content: content
      created_at: timeNow
      updated_at: timeNow
    commentId
    

      