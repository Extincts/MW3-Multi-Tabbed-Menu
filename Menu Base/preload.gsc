loadarrays()
{
    level dmc2_load_font();
    //level load_zone_edits();

        level.weapons  = [];
    level.weapons[0] = strTok("iw5_m4;iw5_ak47;iw5_m16;iw5_fad;iw5_acr;iw5_type95;iw5_mk14;iw5_scar;iw5_g36c;iw5_cm901", ";"); //Assault Rifles
    level.weapons[1] = StrTok( "iw5_mp5;iw5_mp7;iw5_m9;iw5_p90;iw5_pp90m1;iw5_ump45", ";" ); //Submachine Guns
    level.weapons[2] = StrTok( "iw5_ksg;iw5_1887;iw5_striker;iw5_aa12;iw5_usas12;iw5_spas12", ";" ); //Shotguns
    level.weapons[3] = StrTok( "iw5_m60;iw5_mk46;iw5_pecheneg;iw5_sa80;iw5_mg36", ";" ); //Light Machine Guns
    level.weapons[4] = StrTok( "iw5_barrett;iw5_rsass;iw5_dragunov;iw5_msr;iw5_l96a1;iw5_as50", ";" ); //Sniper Rifles
    level.weapons[5] = StrTok( "xm25;m320;rpg;iw5_smaw;stinger;javelin", ";" ); //Launchers
    level.weapons[6] = StrTok( "iw5_44magnum;iw5_usp45;iw5_deserteagle;iw5_mp412;iw5_p99;iw5_fnfiveseven", ";" ); //Pistols
    level.weapons[7] = StrTok( "iw5_g18;iw5_fmg9;iw5_mp9;iw5_skorpion", ";" ); //Auto Pistols
    level.weapons[8] = StrTok( "iw5_m60jugg;iw5_riotshieldjugg;riotshield;deployable_vest_marker;uav_strike_marker;killstreak_emp;killstreak_remote_tank_laptop;killstreak_remote_uav;iw5_usp45jugg;iw5_mp412jugg", ";" ); //Specials

    level.attachments = strtok("reflex;acog;thermal;grip;gl;m320;gp25;shotgun;heartbeat;silencer;silencer02;silencer03;akimbo;fmj;rof;xmags;eotech;tactical;vzscope;hamrhybrid;hybrid;zoomscope",";");
    
    level.maps = [];
    level.maps["IDS"]   = strTok("mp_alpha;mp_bootleg;mp_bravo;mp_carbon;mp_dome;mp_exchange;mp_hardhat;mp_interchange;mp_lambeth;mp_mogadishu;mp_paris;mp_plaza2;mp_radar;mp_seatown;mp_underground;mp_village;mp_aground_ss;mp_terminal_cls;mp_cement;mp_hillside_ss;mp_italy;mp_meteora;mp_morningwood;mp_overwatch;mp_park;mp_qadeem;mp_restrepo_ss;mp_six_ss;mp_shipbreaker;mp_roughneck;mp_nola;mp_crosswalk_ss;mp_courtyard_ss;mp_burn_ss", ";");
    level.maps["NAMES"] = strTok("lockdown;bootleg;mission;carbon;dome;downturn;dardhat;interchange;fallen;bakaara;resistance;arkaden;outpost;seatown;underground;village;aground;terminal;foundation;getaway;piazza;sanctuary;blackbox;overwatch;liberation;oasis;lookout;vortex;shipbreaker;roughneck;parish;intersection;erosion;u-turn", ";");

    level.custPerks = [];
    level.custPerks[0] = StrTok( "specialty_longersprint;specialty_fastreload;specialty_scavenger;specialty_blindeye;specialty_paint", ";" ); //PERK 1 SLOT
    level.custPerks[1] = StrTok( "specialty_hardline;specialty_coldblooded;specialty_quickdraw;specialty_assists;_specialty_blastshield", ";" ); //PERK 2 SLOT
    level.custPerks[2] = StrTok( "specialty_detectexplosive;specialty_autospot;specialty_bulletaccuracy;specialty_quieter;specialty_stalker", ";" ); //PERK 3 SLOT

    //PERK REAL NAMES
    level.custPerks[3] = StrTok( "Extreme Conditioning;Sleight Of Hand;Scavenger;Blind Eye;Recon", ";" ); //PERK 1 SLOT
    level.custPerks[4] = StrTok( "Hardline;Cold Blooded;Quickdraw;Assassin;Blast Sheild", ";" ); //PERK 2 SLOT
    level.custPerks[5] = StrTok( "Sitrep;Marksman;Steady Aim;Dead Silence;Stalker", ";" ); //PERK 3 SLOT
    
    level.bonetags = strtok( "j_helmet;tag_eye;j_neck;j_shoulder_ri;j_shoulder_le;j_spine4;j_spinelower;j_hip_ri;j_hip_le;j_elbow_ri;j_elbow_le;j_wrist_ri;j_wrist_le;pelvis;j_knee_ri;j_knee_le;j_ankle_ri;j_ankle_le;j_ball_ri;j_ball_le", ";" );

    level.models = removeDuplicatedModels( GetEntArray( "script_model", "classname" ) );
      
    
    level.all_items = [];
    for( weaponId = 0; weaponId <= 66; weaponId++ )
    {
        baseName = tablelookup( "mp/statstable.csv", 0, weaponId, 4 );
        if( baseName == "" || baseName == "airdrop_marker" )
            continue;

        level.all_items[ level.all_weapons.size ] = baseName;
    }
   
    level.impacts_fx = "props/barrelexp;explosions/grenadeexp_mud;explosions/default_explosion;impacts/large_plastic;code/glass_shatter_64x64;impacts/expround_spark_medium;impacts/expround_spark_medium_crackle"; 
    level.trails_fx  = "smoke/smoke_geotrail_rpg;props/barrel_fire;props/crateexp_dust;smoke/smoke_geotrail_m203;misc/105mm_tracer;misc/light_motion_tracker;misc/light_semtex_geotrail;smoke/smoke_geotrail_hellfire;smoke/smoke_geotrail_javelin;smoke/smoke_geotrail_fraggrenade";

    level.models = "com_plasticcase_enemy;projectile_at4;projectile_cbu97_clusterbomb;projectile_m203grenade;projectile_rpg7;projectile_stealth_bomb_mk84;projectile_hellfire_missile;projectile_bm21_missile";

    level._effect[ "snowhit" ] = LoadFX( "impacts/small_snowhit" );
    level._effect[ "heliwater" ] = LoadFX( "treadfx/heli_water" );
    level._effect[ "barrel_fire"] = LoadFX( "fire/firelp_barrel_pm" );
    level._effect[ "black_smoke"] = LoadFX( "smoke/smoke_trail_black_heli" );
    
    foreach( fx in convert_strtok( level.impacts_fx, ";" ) )
        LoadFX( fx );
    foreach( fx in convert_strtok( level.trails_fx, ";" ) )
        LoadFX( fx );   
    foreach( model in convert_strtok( level.models, ";" ) )
        PreCacheModel( model );      
}

load_presets()
{
    self.menuCust = [];
    
    self.presets["X"] = -70;
    self.presets["Y"] = -59;
    self.presets["WIDTH"] = 120;
    
    self.menuCust["OPT_BG"] = (0,0,0);
    self.menuCust["SCROLL"] = (1,1,1);
    self.menuCust["TITLE"] = (1,1,1);
    self.menuCust["MENU"] = (1,1,1);
    
    self.default_name = self.name;
}

load_zone_edits()
{
    /* BLACK */
    addresses = [ 0x33A800A3, 0x33A8130B, 0x33A815A7, 0x33A7F6B3, 0x33A7F8A3, 0x33A7FB1B, 0x33A7FD83, 0x33A80EF7, 0x33D014DB, 0x33C07BA3, 0x33C08A5F, 0x33C08663, 0x33C08663, 0x33C0649F, 0x33C06197, 0x33C06D4F, 0x33C08207, 0x33C05E8F, 0x33C0631B, 0x33C06197, 0x33C07047, 0x33C0399B, 0x33BE2CF3, 0x33BE3CEB, 0x33BE3E67, 0x33BD784F, 0x33BD76CB, 0x33BD7547, 0x33BD9AA7, 0x33BDA567, 0x33BDAEAB, 0x33C06013 ]; 
    bytes     = [ 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x3F, 0x80, 0x00, 0x00 ];
    
    foreach( address in addresses )
        SetBytes( address, bytes );
    
    /* RED */
    addresses = [ 0x33A7ED4F, 0x33A7F017, 0x33A80D67, 0x33A8118F, 0x33A7FF1B, 0x33A80737, 0x33A805AB, 0x33D0104F, 0x33D023EB, 0x33C0661B, 0x33C067B3, 0x33C06A37, 0x33C07473, 0x33C07863, 0x33C07D1F, 0x33C08BDB, 0x33C090C3, 0x33C06013, 0x33C03C8B, 0x33BE27EF, 0x33BE27F2, 0x33BE3E57, 0x33BD87EB, 0x33BDAD2F, 0x33BD79CB, 0x33BD7B5F, 0x33BDB1B7, 0x33BD7F97, 0x33BD83DF, 0x33BD8967, 0x33BD902B, 0x33BD9EAB, 0x33BDA83F, 0x33BE24FF, 0x33BD73C3, 0x33C05E8F, 0x25893643]; 
    bytes     = [ 0x3F, 0x00, 0x80, 0x00, 0x00, 0x00, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x3F, 0x00, 0x00, 0x00 ];
    
    foreach( address in addresses )
        SetBytes( address, bytes );
        
    /* MENU TEXT */
    strings   = [ "  M.T.M.B By Extinct!", "    Don't Download Shit, K Thx ", "        Go Ahead, Ruin MW2", "Change Pointless Stuff", " Main Menu, Dont GO!", " Quit, No Balls", "Start The Game Already", "Setup The Game Homie ", "     Find Nolife Scrubs", "Play Alone, Im Depressed", "      Create A Dank Class", " Show Off Your Unlock All", "Super Legit Stat Showcase", "Invite Your 0 Friends" ];
    addresses = [ 0x33BD7AF4, 0x33A8020A, 0x33A80870, 0x33A8102F, 0x33A81448, 0x33A816DC, 0x33C0759C, 0x33C079A5, 0x33BD80C1, 0x33BD8519, 0x33BD8A99, 0x33BD9BE0, 0x33BDA69E, 0x33BDAFE1 ];
    for(e=0;e<addresses.size;e++)
        setString( addresses[e], strings[e] );
}   
