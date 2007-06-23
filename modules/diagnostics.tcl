# bMotion - Diagnostics
#
# vim: foldmethod=marker:foldmarker=<<<,>>>:foldcolumn=3

###############################################################################
# bMotion - an 'AI' TCL script for eggdrops
# Copyright (C) James Michael Seward 2000-2002
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
###############################################################################

# Check if a channel has uppercase letters in it
#
proc bMotion_diagnostic_channel1 { } {
	global bMotionInfo

	#not used now
	return 0

	set err 0
	set cleanChannels [list]
	foreach chan $bMotionInfo(randomChannels) {
		set chan2 [string tolower $chan]
		if {$chan != $chan2} {
			#case difference
			set err 1
		}
		lappend cleanChannels $chan2
	}
	set bMotionInfo(randomChannels) $cleanChannels

	if {$err == 1} {
		putlog "Self-diagnostics indicate you have a channel with a captial letter in in your settings file."
		putlog "	This has been fixed on the fly at load time, but you will need to edit the settings file"
		putlog "	to prevent this reoccuring. Please use all lower-case characters for defining channels."
	}
}

#
# Check the bot's configured for all the channels in the list
proc bMotion_diagnostic_channel2 { } {
	global bMotionInfo

	#not used now 
	return 0

	set notOnChans ""
	set botChans [list]
	foreach chan [channels] {
		lappend botChans [string tolower $chan]
	}

	foreach chan $bMotionInfo(randomChannels) {
		if {[lsearch -exact $botChans $chan] < 0} {
			#configured chan the bot doesn't know about
			append notOnChans "$chan "
		}
	}
	if {$notOnChans != ""} {
		putlog "The following channels are in the settings file, but not configured in eggdrop (typos?): $notOnChans"
	}
}

#
# check the channels are set in the right format
proc bMotion_diagnostic_channel3 { } {
	global bMotionInfo

	#not used now
	return 0

	if [regexp {#[^ ]+ *#.+} [lindex $bMotionInfo(randomChannels) 0]] {
		putlog "bMotion self-diagnostics indicate you have set your channel list in settings.tcl"
		putlog "	incorrectly. You must have a pair of double-quotes around EACH channel, not"
		putlog "	the entire list. bMotion WILL NOT WORK with this configuration error."
	}
}

# bMotion_diagnostic_timers <<<1
# make sure we only have one instance of each timer
proc bMotion_diagnostic_timers { } {
	bMotion_putloglev d * "running level 4 diagnostic on timers"
	set alltimers [timers]
	set seentimers [list]
	foreach t $alltimers {
		bMotion_putloglev 1 * "checking timer $t"
		set t_function [lindex $t 1]
		set t_name [lindex $t 2]
		set t_function [string tolower $t_function]
		if {[lsearch $seentimers $t_function] >= 0} {
			bMotion_loglev d * "bMotion: A level 4 diagnostic has found a duplicate timer $t_name for $t_function ... removing (this is not an error)"
			#remove timer
			killtimer $t_name
		} else {
			#add to seen list
			lappend seentimers $t_function
		}
	}
}

# bMotion_diagnostic_utimers <<<1
# make sure we have only one instance of each utimer
proc bMotion_diagnostic_utimers { } {
	bMotion_putloglev d * "running level 4 diagnostic on utimers"
	set alltimers [utimers]
	set seentimers [list]
	foreach t $alltimers {
		bMotion_putloglev 1 * "checking timer $t"
		set t_function [lindex $t 1]
		set t_name [lindex $t 2]
		set t_function [string tolower $t_function]
		if {[lsearch $seentimers $t_function] >= 0} {
			bMotion_putloglev d * "bMotion: A level 4 diagnostic has found a duplicate utimer $t_name for $t_function ... removing (this is not an error)"
			#remove timer
			killutimer $t_name
		} else {
			#add to seen list
			lappend seentimers $t_function
		}
	}
}

### bMotion_diagnostic_plugins <<<1
# check some plugins loaded
proc bMotion_diagnostic_plugins { } {
	bMotion_putloglev 5 * "bMotion_diagnostic_plugins"
	foreach t {simple complex admin output action_simple action_complex irc_event} {
		set arrayName "bMotion_plugins_$t"
		upvar #0 $arrayName cheese
		if {[llength [array names cheese]] == 0} {
			putlog "bMotion: diagnostics: No $t plugins loaded, something is wrong!"
		}
	}
}

### bMotion_diagnostic_settings <<<1
# check needed settings are defined
proc bMotion_diagnostic_settings { } {
	global bMotionInfo bMotionSettings

	set errors 0

	if {![info exists bMotionInfo(gender)]} {
		putlog "bMotion: diagnostics: Gender not defined, check settings file!"
		set errors 1
	}

	if {![info exists bMotionInfo(orientation)]} {
		putlog "bMotion: diagnostics: Orientation not defined, check settings file!"
		set errors 1
	}

	if {![info exists bMotionSettings(kinky)]} {
		putlog "bMotion: diagnostics: kinky not defined, check settings file!"
		set errors 1
	}

	if {![info exists bMotionSettings(friendly)]} {
		putlog "bMotion: diagnostics: friendly not defined, check settings file!"
		set errors 1
	}

	if {![info exists bMotionSettings(melMode)]} {
		putlog "bMotion: diagnostics: melMode not defined, check settings file!"
		set errors 1
	}

	if {![info exists bMotionSettings(needI)]} {
		putlog "bMotion: diagnostics: needI not defined, check settings file!"
		set errors 1
	}

	if {![info exists bMotionInfo(balefire)]} {
		putlog "bMotion: diagnostics: balefire not defined, check settings file!"
		set errors 1
	}

	if {![info exists bMotionSettings(useAway)]} {
		putlog "bMotion: diagnostics: useAway not defined, check settings file!"
		set errors 1
	}

	if {![info exists bMotionSettings(botnicks)]} {
		putlog "bMotion: diagnostics: botnicks not defined, check settings file!"
		set errors 1
	}

	if {![info exists bMotionSettings(noAwayFor)]} {
		putlog "bMotion: diagnostics: noAwayFor not defined, check settings file!"
		set errors 1
	}

	if {![info exists bMotionSettings(typos)]} {
		putlog "bMotion: diagnostics: typos not defined, check settings file!"
		set errors 1
	}

	if {![info exists bMotionSettings(colloq)]} {
		putlog "bMotion: diagnostics: colloq not defined, check settings file!"
		set errors 1
	}

	if {![info exists bMotionInfo(minRandomDelay)]} {
		putlog "bMotion: diagnostics: minRandomDelay not defined, check settings file!"
		set errors 1
	}

	if {![info exists bMotionInfo(maxRandomDelay)]} {
		putlog "bMotion: diagnostics: maxRandomDelay not defined, check settings file!"
		set errors 1
	}

	if {![info exists bMotionInfo(maxIdleGap)]} {
		putlog "bMotion: diagnostics: maxIdleGap not defined, check settings file!"
		set errors 1
	}

	if {![info exists bMotionInfo(brigDelay)]} {
		putlog "bMotion: diagnostics: brigDelay not defined, check settings file!"
		set errors 1
	}

	if {![info exists bMotionSettings(silenceTime)]} {
		putlog "bMotion: diagnostics: silenceTime not defined, check settings file!"
		set errors 1
	}

	if {![info exists bMotionSettings(languages)]} {
		putlog "bMotion: diagnostics: languages not defined, check settings file!"
		set errors 1
	}

	if {![info exists bMotionSettings(typingSpeed)]} {
		putlog "bMotion: diagnostics: typingSpeed not defined, check settings file!"
		set errors 1
	}

	if {![info exists bMotionSettings(disableFloodChecks)]} {
		putlog "bMotion: diagnostics: disableFloodChecks not defined, check settings file!"
		set errors 1
	}

	if {![info exists bMotionSettings(abstractMaxAge)]} {
		putlog "bMotion: diagnostics: abstractMaxAge not defined, check settings file!"
		set errors 1
	}

	if {![info exists bMotionSettings(abstractMaxNumber)]} {
		putlog "bMotion: diagnostics: abstractMaxNumber not defined, check settings file!"
		set errors 1
	}
	if {![info exists bMotionSettings(factsMaxItems)]} {
		putlog "bMotion: diagnostics: factsMaxItems not defined, check settings file!"
		set errors 1
	}
	if {![info exists bMotionSettings(factsMaxFacts)]} {
		putlog "bMotion: diagnostics: factsMaxFacts not defined, check settings file!"
		set errors 1
	}
	if {![info exists bMotionSettings(bitlbee)]} {
		putlog "bMotion: diagnostics: bitlbee not defined, check settings file!"
		set errors 1
	}

	if {$errors == 1} {
		putlog "bMotion: ### MISSING ONE OR MORE CONFIG SETTINGS ###"
		putlog "bMotion: ### It's likely that your bot will be broken!"
	}
}

### bMotion_diagnostic_userinfo
# Check to see if the user has added IRL and GENDER to their userinfo stuff
proc bMotion_diagnostic_userinfo { } {
	global userinfo-fields
	
	if {![info exists userinfo-fields]} {
		putlog "bMotion: diagnostics indicate you haven't loaded the userinfo TCL script"
		putlog "         this is not required, but is strongly recommended"
		return 
	}

	if {![string match "*GENDER*" ${userinfo-fields}]} {
		putlog "bMotion: diagnostics indicate you haven't added the GENDER field to the"
		putlog "         userinfo.tcl script. This is not required, but is recommended"
		return
	}

	if {![string match "*IRL*" ${userinfo-fields}]} {
		putlog "bMotion: diagnostics indicate you haven't added the IRL field to the"
		putlog "         userinfo.tcl script. This is not required, but is recommended"
		return
	}
	return
}

### bMotion_diagnostic_auto <<<1
proc bMotion_diagnostic_auto { min hr a b c } {
	bMotion_putloglev 5 * "bMotion_diagnostic_auto"
	putlog "bMotion: running level 4 self-diagnostic"
	bMotion_diagnostic_timers
	bMotion_diagnostic_utimers
}
#>>>

if {$bMotion_testing == 0} {
	bMotion_putloglev d * "Running a level 5 self-diagnostic..."

	bMotion_diagnostic_channel1
	bMotion_diagnostic_channel2
	bMotion_diagnostic_channel3
	bMotion_diagnostic_plugins
	bMotion_diagnostic_settings
	bMotion_diagnostic_userinfo

	bMotion_putloglev d * "Diagnostics complete."
}

bind time - "30 * * * *" bMotion_diagnostic_auto
