= godo

* http://rubymatt.rubyforge.org/godo

== DESCRIPTION:

go (to project) do (stuffs)

godo provides a smart way of opening a project folder and invoking a set of commands appropriate to
that project. Examples might be starting mongrel, tailing one or more logs, starting consoles or IRB,
opening empty terminal sessions, or making ssh connections.

godo works by searching your project paths for a search string and attempting to find the project you
are talking about. It makes some straightforward efforts to disambiguate.

godo then uses heuristics (which can be overriden or extended) to figure out what type of project it is,
for example a RoR project using RSpec and Subversion. It then invokes a series of action appropriate to
that project type, each action in its own terminal session.

godo is entirely configured by a YAML file (~/.godo) that contains project types, heuristics, actions,
project paths, and a session controller.
	
godo comes with an iTerm session controller that uses the rb-appscript gem to control iTerm. It should
be straightforward to add a controller for Leopard Terminal or a controller that works in a different way
(e.g. creating new windows instead of new tabs).

== FEATURES/PROBLEMS:

* All-in-one configuration file
* Flexible heuristics for detecting project type
* Flexible actions for running commands

== SYNOPSIS:

godo project-search-string

To override the project type use -o <matcher-name>

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
