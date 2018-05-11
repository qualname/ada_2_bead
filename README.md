# ADA, 2. Beadandó feladat

## Közlekedésszimuláció

Programozd le az alábbi feladatot, és töltsd fel egy zip fáljban a megoldást. A végén az oktató fogadja el a beadandót! A funkcionális helyesség mellett a megoldás nyelvi szépségét, a tanult nyelvi elemek használatának profizmusát is ugyanolyan hangsúllyal beszámítjuk az értékelésbe!

### Alapfeladat

Készíts konkurens programot egy útkereszteződés szimulálására. Az útkereszteződésbe befutó egyik út forgalmát szimuláljuk. Az útkereszteződésben található egy jelzőlámpa (`Lamp`), mely (a magyar rendnek megfelelően) piros, piros-sárga, zöld és sárga fénnyel éghet, ebben a sorrendben váltakozva.  
A lámpát egy időzítős vezérlőegység (`Controller`) váltogatja. Valósítsd meg ezt a két fogalmat taszkok és/vagy védett egységek segítségével.  
A feladatok elvégzéséhez szükség lesz kiírás, illetve randomszám generálás megvalósítására; ezekhez hozz létre egy multifunkcionális nyomtatót (`Multi_Printer`). Ezt védett egységként implementáld.

### A lámpa

A lámpától meg lehet kérdezni, hogy mi az aktuális színe (`Color`), valamint lehet utasítani, hogy változtasson színt (`Switch`). Az utóbbi műveletet a `Controller` hívja. A lámpa mindig írja ki, hogy milyen színre váltott. Kezdetben a lámpa piros legyen.

### A vezérlő

A vezérlő addig kapcsolgatja a lámpát az alábbiak szerint: a piros 3 másodpercig, a piros-sárga 1, a zöld 3, a sárga pedig 2 másodpercig kell, hogy világítson. Ahogy meghívják a leállító `Stop` műveletet, a vezérlő abbahagyja a lámpa kapcsolgatását, és befejezi működését.

### A jármű

Készíts jármű taszkokat (`Vehicle`), melyek diszkriminánsként a rendszámukat kapják meg `String`-re mutató mutatóként. A jármű akkor haladhat át a kereszteződésen, ha zöld a lámpa. Ha a lámpa nem zöld, akkor 0.2 másodpercenként újra megnézi a lámpát, amíg az zöldre nem vált. A jármű a kereszteződéshez érkezéskor, illetve a kereszteződésen való áthaladáskor kiírja a rendszámát.

### A szimuláció

A főprogram indítson el 10 járművet, fél másodperces időközönként. Ezután 10 másodperc késleltetéssel hívjuk meg a `Controller` `Stop `belépési pontját és ezzel állítsuk le a szimulációt. A fenti művelet kihagyásával is le kell tudnia állni a programnak, ha minden jármű átért a kereszteződésen.

### Feladat folytatása

### A kereszteződés

Oldjuk meg most azt, hogy a kereszteződésen egyszerre csak egy jármű haladhat át: a járművek a kereszteződéshez érkezés sorrendjében tudnak áthaladni. Ehhez vezessünk be egy kereszteződés (`Crossroads`) védett egységet vagy taszkot. A kereszteződésnek van egy `Cross` művelete, mely `Duration` típusú paraméterként megkapja, hogy mennyi ideig tart a járműnek keresztülhaladnia rajta. Ezt a műveletet a jármű fogja meghívni. A művelet csak akkor hajtódik végre, ha a lámpa zöld. A `Cross` törzse egy `delay` utasításból áll, mely annyi ideig várakoztatja meg a hívót, amennyit az paramétereként átadott.

### Az átjutás

Amikor a jármű a kereszteződéshez ér, hívja meg a `Crossroads`nak a `Cross` műveletét. Az átkelési időt generálja random 0.5 és 1.5 között. Ha a randevú azonnal sikerül, akkor ennyi idő alatt átjut a kereszteződésen. Ha a randevú nem sikerül azonnal, akkor a járműnek meg kell állnia, és újra meg kell hívnia a `Cross` műveletet, immár 2.5 és 3.5 közötti számot átadva paraméterként, mert megállás után már ennyi ideig tart a kereszteződésen keresztülhaladni.

### A kereszteződés és a lámpa kommunikációja

Ahhoz, hogy a szimuláció teljes legyen, a lámpának értesítenie kell a kereszteződést arról, hogy átkapcsolták. Legyen a kereszteződésnek egy `Wake_Up` művelete, amit meghívva rá tudjuk venni a `Crossroads`-ot, hogy újra ellenőrizze a `Cross` művelethez tartozó őrfeltételt. Ezt a `Wake_Up` műveletet közvetlenül nem hívhatja meg a lámpa, egy közbeékelt ágensre van szükség. Hozzunk létre egy ilyen ágens taszkot a lámpában, amikor átváltják. Az ágens taszk meghívja a `Wake_Up` műveletet, majd befejeződik.

Folyamatábrás segítség [itt](crossroad.png)

Jó munkát, Oktatók és Demonstrátorok
