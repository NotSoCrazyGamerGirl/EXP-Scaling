#===============================================================================
# "EXP Scaling v20.1"
#-------------------------------------------------------------------------------
# This plugin allows you to dynamically adjust the amount of EXP earned by
# Pokemon in battles based on a selected variable value. The plugin can be
# turned on or off using a switch.
#
# Usage:
# - Set the variable ID you want to use to determine the EXP multiplier in the
#   "VARIABLE_ID" constant.
# - Set the EXP multiplier for each variable value in the "get_exp_multiplier"
#   method using a case statement.
# - Set the switch ID to use to enable/disable the plugin in the
#   "ENABLED_SWITCH_ID" constant. If the switch is set to ON, the plugin will
#   only apply the EXP multiplier when the switch is also ON.
#
# The EXP multiplier will be applied to the total EXP earned by the Pokemon in
# battles. The plugin can be turned on or off by commenting out the relevant
# lines of code.
#
# Compatibility:
# - This plugin is designed for use with Pokemon Essentials v20.1.
#
# Credits:
# - Written by [Your Name Here]
# - Special thanks to [People who helped or inspired you]
#===============================================================================

module EXPScaling
  # Set the variable ID you want to use to determine the EXP multiplier
  VARIABLE_ID = 1

  # Set the switch ID to enable/disable the plugin
  ENABLED_SWITCH_ID = 1

  # Determine if the plugin is enabled based on the switch value
  def self.enabled?
    return true if ENABLED_SWITCH_ID == 0 # Always enabled if switch ID is 0.
    return $game_switches[ENABLED_SWITCH_ID]
  end


  # Determine the EXP multiplier based on the value of the selected variable
  def self.get_exp_multiplier
    variable_value = $game_variables[VARIABLE_ID]
    case variable_value
    when 1
      return 1.1 # 10% boost
    when 2
      return 1.0 # normal
    when 3
      return 0.333 # 1/3
    else
      return 1.0 # normal
    end
  end

  # Apply the EXP multiplier to the total EXP earned by the Pokemon
  def self.apply_exp_multiplier(exp, pokemon)
    return exp unless enabled? # Return normal EXP if plugin is disabled
    exp_multiplier = get_exp_multiplier
    exp_multiplier = 0 if exp_multiplier < 0
    exp = (exp * exp_multiplier).to_i
    return exp
  end
end

class BattleManager
  class << self
    # Override the calculate_exp method to apply the EXP multiplier
    alias calculate_exp_real calculate_exp
    def calculate_exp(*args)
      exp = calculate_exp_real(*args)
      pokemon = args[0]
      exp = EXPScaling.apply_exp_multiplier(exp, pokemon)
      return exp
    end
  end
end
