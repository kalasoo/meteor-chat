# Routing
Router.map () ->
  # Home
  @route 'home',
    path: '/'
    layoutTemplate: 'layout'
    template: 'chatRoom'
    yieldTemplates:
      'chatRoomHeader': {to: 'header'}
    waitOn: () ->
      Meteor.subscribe 'comments'

  # Chat Logs
  @route 'logs',
    path: '/logs'
    layoutTemplate: 'layout'
    template: 'logs'
    yieldTemplates:
      'logsHeader': {to: 'header'}
    waitOn: () ->
      Meteor.subscribe 'allComments'