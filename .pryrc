#
#The following lines are needed to include rails.console commands such as "reload"
#
require './config/environment.rb'
require 'rails/console/app'
include Rails::ConsoleMethods
#
#There is an unreadable blue color in the Pry output. It is both the :blue (ANSI "\e[34m") and :bright_blue.  
#This line changes the CodeRay comment color from blue to cyan (ANSI "\e[36m")
#
CodeRay::Encoders::Terminal::TOKEN_COLORS[:comment] = {:self=>"\e[1;36m", :char=>"\e[37m", :delimiter=>"\e[37m"}
#
#These lines change the Pry::ls command colors that are packaged as :blue or :bright_blue, which both
#seem to be the same unreadable blue color.  :default is white.
#
Pry.config.ls.heading_color = :yellow
Pry.config.ls.instance_var_color = :default
Pry.config.ls.class_var_color = :default
Pry.config.ls.class_constant_color = :red
Pry.config.ls.private_method_color = :default
Pry.config.ls.protected_method_color = :default

