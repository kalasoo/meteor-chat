Meteor.subscribe 'comments'

# Initiate the comment input content
Meteor.startup () ->
  Session.set 'content', ''

# Create a comment
Template.commentInput.events
  'keyup textarea': (event, template) ->
    Session.set 'content', template.$('textarea').val()
  'click button': (event, template) ->
    if Meteor.userId()?
      Meteor.call 'createComment', Session.get('content')
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
  if owner? then displayName(owner) else 'Unkown'

Template.commentBox.showTime = (time) ->
  new Date(time).toLocaleString()

Template.commentBox.events
  'click .remove': () ->
    Comments.remove @_id
    false
  'keypress .content': (event, template) ->
    if event.charCode is 13
      $content = $ event.target
      content = $.trim $content.text()
      if content.length > 0
        Comments.update @_id,
          $set:
            content: content
            updated_at: Date.now()
        $content
          .blur()
          .addClass 'animated fadeIn'
          .one 'webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', () ->
            $content.removeClass 'animated fadeIn'

