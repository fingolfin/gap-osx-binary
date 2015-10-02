^^Jgap> preform := rec( name := "ForComplement",^^J> fScreen := function( H, p )^^J> return Subgroup( H, GeneratorsOfGroup( H ){[2,3,4]});^^J> end);;^^Jgap> form := Formation(preform);^^Jformation of ForComplement groups^^Jgap> SetIsIntegrated(form, true);^^J
^^Jgap> comp := FNormalizerWrtFormation(s4, form); Size(comp);^^JGroup([ f1, f2 ])^^J6^^J
