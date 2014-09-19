Meteor.subscribe 'comments'

# Initiate the comment input content
Meteor.startup () ->
  Session.set 'content', ''
  Session.set 'tempId', Random.id()

# Create a comment
Template.commentInput.events
  'keyup textarea': (event, template) ->
    Session.set 'content', template.$('textarea').val()
  'click button': (event, template) ->
    userId = Meteor.userId()
    ownerId = if userId? then userId else Session.get('tempId')
    lastComment = Comments.findOne {owner: ownerId}, {sort: {created_at: -1}}
    if lastComment? and (Date.now() - lastComment.created_at < 3000)
      alert('You have added too many comments!')
    else
      Meteor.call 'createComment', Session.get('content'), ownerId
      console.log $('.comments')
      $('.comments').scrollTop 0
    template.$('textarea').val ''
    Session.set 'content', ''

Template.commentInput.creatorName = () ->
  currentUser = Meteor.user()
  if currentUser?
    ", #{displayName(currentUser)}"
  else
    ''

# Show comments
Template.commentBoxes.comments = () ->
  Comments.find {}, {sort: {created_at: -1}}

# Show a comment
Template.commentBox.mine = () ->
  id = Meteor.userId()
  id? and @owner is id

Template.commentBox.creatorName = (id) ->
  owner = Meteor.users.findOne id
  if owner? then displayName(owner) else "#{id.slice(0, 2)}····#{id.slice(-5)}"

Template.commentBox.showTime = (time) ->
  new Date(time).toLocaleString()

Template.commentBox.events
  'click .remove': () ->
    Comments.remove @_id
    false
  'keypress .content': (event, template) ->
    $content = $ event.target
    if event.charCode is 13
      content = $.trim $content.text()
      if content.length > 0
        Comments.update @_id,
          $set:
            content: content
            updated_at: Date.now()
        , () =>
          $content.html content
        $content
          .blur()
          .addClass 'animated fadeIn'
          .one 'webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', () ->
            $content.removeClass 'animated fadeIn'
      else
        $content
          .html @content
          .addClass 'animated shake'
          .one 'webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', () ->
            $content.removeClass 'animated shake'
        event.preventDefault()
