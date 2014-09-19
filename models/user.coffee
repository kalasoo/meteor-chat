@displayName = (user) ->
  if user.profile and user.profile.name
    return user.profile.name
  user.emails[0].address