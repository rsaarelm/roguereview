Hack
====

Notes on Hack 1.0.3. The predecessor of NetHack from the 80s.

Source code overview
--------------------

      134    775   4582 hack-1.0.3/config.h
        2      7     40 hack-1.0.3/date.h
       12     74    456 hack-1.0.3/def.edog.h
       24    121    756 hack-1.0.3/def.eshk.h
       42    249   1585 hack-1.0.3/def.flag.h
       16     39    299 hack-1.0.3/def.func_tab.h
       15     65    415 hack-1.0.3/def.gen.h
       12     40    279 hack-1.0.3/def.gold.h
       26    101    641 hack-1.0.3/def.mkroom.h
       60    297   2094 hack-1.0.3/def.monst.h
       60    273   1874 hack-1.0.3/def.objclass.h
      289   1506  10397 hack-1.0.3/def.objects.h
       48    216   1457 hack-1.0.3/def.obj.h
       25     90    719 hack-1.0.3/def.permonst.h
       52    205   1255 hack-1.0.3/def.rm.h
       27    102    656 hack-1.0.3/def.trap.h
       13     41    285 hack-1.0.3/def.wseg.h
      163    669   4667 hack-1.0.3/hack.h
       12     48    363 hack-1.0.3/hack.mfndpos.h
      227    686   5967 hack-1.0.3/hack.onames.h
       47    117    801 hack-1.0.3/alloc.c
      434   1467  10376 hack-1.0.3/hack.apply.c
       95    369   2489 hack-1.0.3/hack.bones.c
      798   2695  18269 hack-1.0.3/hack.c
      301    890   5966 hack-1.0.3/hack.cmd.c
       43    187   1121 hack-1.0.3/hack.Decl.c
      486   1547  11400 hack-1.0.3/hack.do.c
      413   1475  10491 hack-1.0.3/hack.dog.c
      289    912   6165 hack-1.0.3/hack.do_name.c
      336   1000   7549 hack-1.0.3/hack.do_wear.c
      459   1446  10482 hack-1.0.3/hack.eat.c
      639   2117  15946 hack-1.0.3/hack.end.c
      306   1011   7014 hack-1.0.3/hack.engrave.c
      358   1215   9276 hack-1.0.3/hack.fight.c
      860   2866  18924 hack-1.0.3/hack.invent.c
       53    183   1338 hack-1.0.3/hack.ioctl.c
      285    816   6400 hack-1.0.3/hack.lev.c
      495   1480  10730 hack-1.0.3/hack.main.c
      198    678   4496 hack-1.0.3/hack.makemon.c
      363    997   8080 hack-1.0.3/hack.mhitu.c
      739   2554  16791 hack-1.0.3/hack.mklev.c
      136    463   2961 hack-1.0.3/hack.mkmaze.c
      148    419   2964 hack-1.0.3/hack.mkobj.c
      274    945   6769 hack-1.0.3/hack.mkshop.c
      838   2851  20272 hack-1.0.3/hack.mon.c
       79    355   2652 hack-1.0.3/hack.monst.c
      547   1729  11399 hack-1.0.3/hack.objnam.c
      160    531   3885 hack-1.0.3/hack.o_init.c
      203    547   4630 hack-1.0.3/hack.options.c
      401   1185   8006 hack-1.0.3/hack.pager.c
      386   1085   8839 hack-1.0.3/hack.potion.c
      660   1862  12958 hack-1.0.3/hack.pri.c
      539   1698  13016 hack-1.0.3/hack.read.c
       81    248   1930 hack-1.0.3/hack.rip.c
       63    208   1492 hack-1.0.3/hack.rumors.c
      238    774   5903 hack-1.0.3/hack.save.c
      133    431   3129 hack-1.0.3/hack.search.c
      973   3116  23601 hack-1.0.3/hack.shk.c
      140    476   4252 hack-1.0.3/hack.shknam.c
      203    683   4958 hack-1.0.3/hack.steal.c
      276    913   5565 hack-1.0.3/hack.termcap.c
       62    186   1377 hack-1.0.3/hack.timeout.c
      192    518   3803 hack-1.0.3/hack.topl.c
       38    105    656 hack-1.0.3/hack.track.c
      447   1290   9891 hack-1.0.3/hack.trap.c
      301    954   6334 hack-1.0.3/hack.tty.c
      357   1243   8053 hack-1.0.3/hack.u_init.c
      430   1634  10445 hack-1.0.3/hack.unix.c
      259    917   5880 hack-1.0.3/hack.vault.c
       16     46    323 hack-1.0.3/hack.version.c
       99    348   2473 hack-1.0.3/hack.wield.c
      189    682   4930 hack-1.0.3/hack.wizard.c
      183    588   4226 hack-1.0.3/hack.worm.c
       65    210   1371 hack-1.0.3/hack.worn.c
      642   1990  14672 hack-1.0.3/hack.zap.c
      217    650   4452 hack-1.0.3/makedefs.c
       30     43    280 hack-1.0.3/rnd.c
    19261  63549 451238 total

`config.h`
`date.h`
`def.edog.h`
`def.eshk.h`
`def.flag.h`
`def.func_tab.h`
`def.gen.h`
`def.gold.h`
`def.mkroom.h`
`def.monst.h`
`def.objclass.h`
`def.objects.h`
`def.obj.h`
`def.permonst.h`
`def.rm.h`
`def.trap.h`
`def.wseg.h`
`hack.h`
`hack.mfndpos.h`
`hack.onames.h`
`alloc.c`
`hack.apply.c`
`hack.bones.c`
`hack.c`
`hack.cmd.c`
`hack.Decl.c`
`hack.do.c`
`hack.dog.c`
`hack.do_name.c`
`hack.do_wear.c`
`hack.eat.c`
`hack.end.c`
`hack.engrave.c`
`hack.fight.c`
`hack.invent.c`
`hack.ioctl.c`
`hack.lev.c`
`hack.main.c`
`hack.makemon.c`
`hack.mhitu.c`
`hack.mklev.c`
`hack.mkmaze.c`
`hack.mkobj.c`
`hack.mkshop.c`
`hack.mon.c`
`hack.monst.c`
`hack.objnam.c`
`hack.o_init.c`
`hack.options.c`
`hack.pager.c`
`hack.potion.c`
`hack.pri.c`
`hack.read.c`
`hack.rip.c`
`hack.rumors.c`
`hack.save.c`
`hack.search.c`
`hack.shk.c`
`hack.shknam.c`
`hack.steal.c`
`hack.termcap.c`
`hack.timeout.c`
`hack.topl.c`
`hack.track.c`
`hack.trap.c`
`hack.tty.c`
`hack.u_init.c`
`hack.unix.c`
`hack.vault.c`
`hack.version.c`
`hack.wield.c`
`hack.wizard.c`
`hack.worm.c`
`hack.worn.c`
`hack.zap.c`
`makedefs.c`
`rnd.c`
