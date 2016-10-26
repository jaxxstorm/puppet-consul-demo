# main node definitions
node default {

  # define some run stages
  stage { 'setup': }
  stage { 'pre': }
  stage { 'post': }
  Stage['setup'] -> Stage['pre'] -> Stage['main'] -> Stage['post']

  if ! $role {
    notify {'role is not defined, setting to base role': }
    $role = 'base'
  }
  
  include "roles::${role}"

}
