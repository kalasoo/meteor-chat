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
  createComment: (content, tempId) ->
    check content, NonEmptyString
    check tempId, NonEmptyString
    ownerId = if @userId? then @userId else tempId
    timeNow = Date.now()
    lastComment = Comments.findOne {owner: ownerId}, {sort: {created_at: -1}}
    # No comment when theinterval is smaller than 3 sec
    if lastComment? and (timeNow - lastComment.created_at < 3000)
      alert('You have added too many comments!')
    else
      commentId = Random.id()
      Comments.insert
        _id: commentId
        owner: ownerId
        content: content
        created_at: timeNow
        updated_at: timeNow
      commentId
    

      