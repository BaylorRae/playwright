require 'playwright/version'

module Playwright
  autoload :Stage, 'playwright/stage'
  autoload :Scene, 'playwright/scene'
  autoload :Props, 'playwright/props'
  autoload :Narrator, 'playwright/narrator'
  autoload :ActorNotRegistered, 'playwright/errors'
  autoload :SceneNotRegistered, 'playwright/errors'
end
