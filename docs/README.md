# DCS World - B-21 Raider

![B-21 Raider](docs/b-21-raider-the-future-hero-black_Original%20file.webp)

This is a free, open-source independent module of the **Northrop Grumman B-21 Raider** for **DCS World**. By independent, it means it does not require any other official DCS modules to work.

> **Development Status: Alpha (v0.1.0-alpha)**  
> This project is in a **very early stage of development (Alpha)**. Core flight dynamics, cockpit systems, animations, and weapons integration are actively under construction and subject to frequent changes.

<p align="center">
  <img src="docs/Code_Generated_Image.png" alt="509th B-21 Raider Logo" width="240" />
</p>

---

## Credits & 3D Model

* **External 3D Model:** Based on the [Northrop Grumman B-21 Raider](https://flightsim.to/addon/46567/northrop-grumman-b-21-raider) add-on originally created for Microsoft Flight Simulator (FlightSim.to), converted and adapted for DCS World.
* **DCS Implementation & Systems:** Mikkaell-Filipe

---

## Installation

1. Download or clone this repository.
2. Place the `B-21 RAIDER` folder inside your DCS Saved Games directory:
   ```text
   C:\Users\<YourUsername>\Saved Games\DCS\Mods\aircraft\B-21 RAIDER
   ```
   *(If you use the Open Beta branch folder structure, place it inside `Saved Games\DCS.openbeta\Mods\aircraft\`).*
3. Restart DCS World.

---

## Changelog

### Version 0.1.0-alpha (Initial Release)

#### Added
* Initial integration of the B-21 Raider 3D model into DCS World (sourced from [FlightSim.to](https://flightsim.to/addon/46567/northrop-grumman-b-21-raider)).
* Basic aircraft configuration (`entry.lua`), aerodynamics, propulsion, and landing gear setup.
* Basic flight controls and cold/hot start definitions.

#### Known Issues / TODO
* Refine flight model parameters, weight distribution, and high-altitude performance.
* Complete custom cockpit 3D model, displays, and clickable systems.
* Implement internal weapons bay animations and payload options.
* Add custom sound effects and additional liveries.