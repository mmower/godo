= godo

* version: 1.0.5
* released: 2008-03-11
* http://simplyruby.rubyforge.org/godo

== DESCRIPTION:

go (to project) do (stuffs)

godo provides a smart way of opening a project folder in multiple terminal tabs and, in each tab,
invoking a commands appropriate to that project. For example if the folder contains a Rails project
the actions might include: starting mongrel, tailing one or more logs, starting consoles or IRB
sessions, tailing production logs, opening an editor, running autospec, or gitk.

godo works by searching your project paths for a given search string and trying to match it against
paths found in one or more configured project roots. It will make some straightforward efforts to
disambiguate among multiple matches to find the one you want.

godo then uses configurable heuristics to figure out what type of project it is, for example "a RoR
project using RSpec and Subversion". From that it will invokes a series of action appropriate to the
type of project detected with each action being run, from the project folder, in its own terminal
session.

godo is entirely configured by a YAML file (~/.godo) that contains project types, heuristics, actions,
project paths, and a session controller. A sample configuration file is provided that can be installed
using godo --install.
	
godo comes with an iTerm session controller for MacOSX that uses the rb-appscript gem to control iTerm
(see lib/session.rb and lib/sessions/iterm_session.rb). It should be relatively straightforward to add
new controller (e.g. for Leopard Terminal.app), or a controller that works in a different way (e.g. by
creating new windows instead of new tabs). There is nothing MacOSX specific about the rest of godo so
creating controllers for other unixen should be straightforward if they can be controlled from ruby.

godo is a rewrite of my original 'gp' script (http://matt.blogs.it/entries/00002674.html) which fixes
a number of the deficiencies of that script, turns it into a gem, has a better name, and steals the
idea of using heuristics to detect project types from Solomon White's gp variant (http://onrails.org/articles/2007/11/28/scripting-the-leopard-terminal).
  
godo now includes contributions from Lee Marlow <lee.marlow@gmail.com> including support for project
level .godo files to override the global configuration, support for Terminal.app, and maximum depth
support to speed up the finder.
	
godo lives at the excellent GitHub: http://github.com/mmower/godo/ and accepts patches and forks.

== FEATURES/PROBLEMS:

* All-in-one configuration file
* Flexible heuristics for detecting project type
* Flexible actions for running commands
* Project level customizations

== SYNOPSIS:

To install the default configuration (will not overwrite an existing configuration file)

godo --install

To open a project with it's actions

godo <project>

Where project is a search term that will match part of the project path name.

If the project has a .godo file at its root, then those actions will be used
instead of using the heuristics.  A project level .godo file can reference
actions defined in ~/.godo, a group of actions by project type, and
arbitrary commands.

Here's a sample project level .godo file:
---
actions:
  - terminal
  - command: echo 'tab before matcher'
    label: This tab goes before the project matcher
  - matcher: rails+git
  - command: echo 'tab after matcher'
  - terminal

To open a project and override the project type (i.e. do not use heuristics nor
a project level .godo file):

godo -o <matcher> <project>

== REQUIREMENTS:

* Trollop
* rb-appscript

== INSTALL:

* sudo gem install godo
* godo --install
* mate|vi|emacs ~/.godo

== LICENSE:

(The MIT License)

Copyright (c) 2008 Matt Mower <self@mattmower.com>

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
