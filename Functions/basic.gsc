godmode()
{
    if(!isDefined(self.godmode))
    {
        self.godmode = true;
        self EnableInvulnerability();
    }
    else
        self DisableInvulnerability();
    self SetColour(self.godmode, "basicOpts", 0);
}

EnableInvulnerability()
{
    self thread DoEnableinvulnerability();
}

DoEnableinvulnerability()
{
    self endon("disconnect");
    if(self.maxhealth > 100)
        return;
    
    while( self.maxhealth > 100 )
    {
        self.maxhealth = 99999999;
        self.health    = 99999999;
        wait .05;
    }
}

DisableInvulnerability()
{
    self.godmode   = undefined;
    self.maxhealth = 100;
    self.health    = 100;
}

noClipExt()
{
    self endon("disconnect");
    self endon("game_ended");
    
    if(!isDefined( self.noclipBind ))
    {
        self.noclipBind = true;
        self setColour( self.noclipBind, "basicOpts", 1 );
        while(isDefined( self.noclipBind ))
        {
            if(self fragButtonPressed())
            {
                if(!isDefined(self.noclipExt))
                    self thread doNoClipExt();
            }
            wait .05;
        }
        self setColour( self.noclipBind, "basicOpts", 1 );
    }
    else 
        self.noclipBind = undefined;
}

doNoClipExt()
{
    self endon("disconnect");
    self endon("noclip_end");
    self disableWeapons();
    self disableOffHandWeapons();
    clip = spawn("script_origin", self.origin);
    self playerLinkTo(clip);
    self.noclipExt = true;
    self EnableInvulnerability();
    while(true)
    {
        vec = anglesToForward(self getPlayerAngles()); 
        end = (vec[0]*60,vec[1]*60,vec[2]*60);
        if(self attackButtonPressed()) clip.origin = clip.origin+end;
        if(self adsButtonPressed()) clip.origin = clip.origin-end;
        if(self meleeButtonPressed()) break;
        wait .05;
    }
    clip delete();
    self enableWeapons();
    self enableOffHandWeapons();
    if(!isDefined(self.godmode))
      self DisableInvulnerability();
    self.noclipExt = undefined;
}

ufoMode()
{
    if( !IsDefined( self.ufo_mode ) )
    {
        self.ufo_mode = true;
        SetByte( 0x01C30A0C + (self GetEntityNumber() * 0x38EC), 0x01 );
    }
    else 
    {
        self.ufo_mode = undefined;
        SetByte( 0x01C30A0C + (self GetEntityNumber() * 0x38EC), 0x00 );
    }
    self setColour( self.ufo_mode );
    
    /*if(isDefined(self.noclipBind)) return self iprintln("^1Error^7: Please turn off noclip before using UFO Mode.");
    self thread drawInstructions( "UFO Mode Instructions;Move Up - [{+speed_throw}] | Move Down - [{+attack}];Move Forward - [{+frag}] | Exit UFO Mode - [{+melee}]", "126;165;220" ); // num chars * 6.125
    self enableInvulnerability();
    self disableWeapons();
    self disableOffHandWeapons();
    clip = modelSpawner(self.origin,"script_origin");
    self playerLinkTo(clip);
    while(1)
    {
        vec = anglesToForward(self getPlayerAngles());
        vecU = anglesToUp(self getPlayerAngles());
        end = (vec[0]*35,vec[1]*35,vec[2]*35);
        endU = (vecU[0]*30,vecU[1]*30,vecU[2]*30);
        if(self attackButtonPressed())  clip.origin = clip.origin - endU;
        if(self adsButtonPressed())     clip.origin = clip.origin + endU;
        if(self fragButtonPressed())    clip.origin = clip.origin + end;
        if(self meleeButtonPressed())   break;
        wait .05;
    }
    clip delete();
    self enableWeapons();
    self enableOffHandWeapons();
    if(!isDefined(self.godmode))
        self DisableInvulnerability();
    self notify( "reopen_menu" );*/
}

thirdPerson()
{
    if(!isDefined(self.thirdPerson))
        self.thirdPerson = true;
    else self.thirdPerson = undefined;
    self setClientThirdPerson( returnBoolean(self.thirdPerson) );
    self setColour(self.thirdPerson);
}

setClientThirdPerson( bool )
{
    self setThirdPersonDOF( bool );
    self setClientDvar( "cg_thirdPerson", bool );
}

infiniteAmmo( reload )
{
    self endon("disconnect");
    level endon("game_ended");

    if( !isDefined( self.infAmmo ) )
    {
        self.infAmmo = true;
        self SetColour(self.infAmmo, "basicOpts", 5);
        while( isDefined( self.infAmmo ) )
        {
            weapon = self getcurrentweapon();
            if( weapon != "none" && reload == "reload" ) 
                self givemaxammo( weapon );
            else if( reload != "reload" ) 
                self setWeaponAmmoClip( weapon, weaponclipsize( weapon ));
            wait .05;
        }
        self SetColour(self.infAmmo, "basicOpts", 5);
    }
    else self.infAmmo = undefined;
}

infiniteEquip()
{
    self endon("disconnect");
    level endon("game_ended");

    if( !isDefined( self.infEquip ) )
    {
        self.infEquip = true;
        self SetColour(self.infEquip);
        
        while( isDefined( self.infEquip ) )
        {
            if( self getcurrentoffhand() != "none" ) 
                self givemaxammo( self getcurrentoffhand() );
            wait .05;
        }
        self SetColour(self.infEquip);
    }
    else self.infEquip = undefined;
}

fovEdit( value )
{
    self setClientDvar( "cg_fov", value );
    self.fovValue = value;
}

fovScaleEdit( value )
{
    self setClientDvar( "cg_fovScale", value );
    self.fovScaleValue = value;
}

setAllPerks( clear )
{
    if(isDefined(clear))
    {
        self.addAllPerks = undefined; self.clearPerks = true;
        for(e=0;e<3;e++) for(i=0;i<level.custPerks[e].size;i++)
            self removePerk( level.custPerks[e][i] );
        self notify("clear_perks");
    }
    else
    {
        self.clearPerks = undefined; self.addAllPerks = true;
        for(e=0;e<3;e++) for(i=0;i<level.custPerks[e].size;i++)
            self _setPerkFunction( level.custPerks[e][i] );
    }
    self SetColour(self.addAllPerks, "addPerks", 0);
    self SetColour(self.clearPerks, "removePerks", 0);
}

_setPerkFunction( perkName, noPrint )
{
    if( self _hasPerk( perkName ) )
        return self IPrintLn( "Perk Already Acquired" );
    
    perkName = checkForPerkUpgrade( perkName ); 
    
    if(!IsDefined( noPrint ))
        self IPrintLn( "Perk Given: " + perkName );  
    self _setPerk( perkName, false );
    self thread watchSetPerkDeath( perkName );
    self maps\mp\_matchdata::logKillstreakEvent( perkName + "_ks", self.origin );
}
    
checkForPerkUpgrade( perkName )
{
    perkUpgrade = tablelookup( "mp/perktable.csv", 1, perkName, 8 );
    
    if ( perkUpgrade == "" || perkUpgrade == "specialty_null" )
        return "specialty_null";
    return ( perkUpgrade );
}

watchSetPerkDeath( perkName )
{
    self endon( "disconnect" );
    self endon( "clear_perks" );
    self waittill( "spawned_player" );
    
    self _unsetPerk( perkName, true );
    self _setPerkFunction( perkName );
}

removePerk( perk )
{
    self IPrintLn( "Perk Removed: " + perk ); 
    self _unsetPerk( perk );
    perk = checkForPerkUpgrade( perk );
    self _unsetPerk( perk );
}

changeAppearance( kit, team )
{
    self DetachAll();
    if(isDefined( game[team+"_model"][ kit ] ))
        [[game[team+"_model"][ kit ]]]();
    self notify ( "changed_kit" );
}

cycleAppearance()
{
    if(!IsDefined( self.cycleAppearance ))
    {
        self.cycleAppearance = true;
        self thread doCycleAppearance();
    }
    else 
    {
        self.cycleAppearance = false;
        self notify("stop_cycleAppearance");
    }
    self setColour( self.cycleAppearance );
}

doCycleAppearance()
{
    self endon("disconnect");
    self endon("stop_cycleAppearance");
    
    list = ["SMG", "ASSAULT", "GHILLIE", "SNIPER", "LMG", "RIOT", "SHOTGUN", "ASSAULT", "JUGGERNAUT"];
    team = [self.team, getOtherTeam( team )];
    
    while(IsDefined( self.cycleAppearance ))
    {
        for(e=0;e<1;e++)
        {
            foreach( kit in list )
            {
                self DetachAll();
                if(isDefined( game[team[e] + "_model"][ kit ] ))
                    [[game[team[e] + "_model"][ kit ]]]();
                self notify( "changed_kit" );
                wait .3;
            }
        }
        wait .05;
    }
}

invisibility()
{
    if( !IsDefined( self.invisibility ) )
    {
        self.invisibility = true;
        self SetModel( "" );
        self hide();
    }
    else 
    {
        self.invisibility = undefined;
        self changeAppearance( "ASSAULT", self.team );
        self show();
    }
    self setColour( self.invisibility );
}

clone( which )
{
    if(isDefined(self.invisibility))
        return self iprintln("^1Error^7: Disable Invisibility before using spawn clone.");
    if( which == "clone" )
        self clonePlayer( 1 );
    if( which == "dead" )
        self clonePlayer( 1 ) startRagdoll( 1 );
    if( which == "statue" )
    {
        if(!isDefined( self.statue ) || self.statue.size > 5)
            self.statue = [];
        if(self.statue.size >= 5)
            array_delete( self.statue );
        self.statue[ self.statue.size ] = modelSpawner(self.origin, self.model, self.angles);
    }
}

setPlayerVision( vision )
{
    if( vision == "default" )
        vision = "";
    self VisionSetNakedForPlayer( vision, 2 ); // "" - go to default visionset
}

set_movement_speed( val )
{
    self endon("disconnect");
    if( !IsDefined( self.movement_speed ) )
    {
        self.movement_speed = true;
        self setColour( self.movement_speed, "basicOpts", 16 );
        
        while( IsDefined( self.movement_speed ) )
        {
            self setmovespeedscale( val );
            wait .1;
        }
    }
    else
    {
        self.movement_speed = undefined;
        self setmovespeedscale( 1 );
        self setColour( self.movement_speed, "basicOpts", 16 );
    }
}