# DCS World B-21 Raider (EFM)

![B-21 Raider](docs/b-21-raider-the-future-hero-black_Original%20file.webp)

This is a free open-source EFM **Northrop Grumman B-21 Raider** independent module for **DCS World**. By independent it is meant that it does not require any other modules to work.

The development is in an early **Alpha / Prototype stage (v0.2.0-alpha)**, focusing on External Flight Model (EFM) physics, fly-by-wire (FBW) laws, and systems integration.

<p align="center">
  <img src="docs/Code_Generated_Image.png" alt="509th B-21 Raider Patch" width="220" />
</p>

## Credits & 3D Model

- **External 3D Model:** Adapted from the [Northrop Grumman B-21 Raider](https://flightsim.to/addon/46567/northrop-grumman-b-21-raider) add-on for Microsoft Flight Simulator (FlightSim.to).
- **EFM & DCS Systems:** [Mikkaell-Filipe](https://github.com/Mikkaell-Filipe)

## Installation

1. Download or clone this repository.
2. Copy the `B-21 RAIDER` folder to your DCS Saved Games directory:
   ```text
   C:\Users\<YourUser>\Saved Games\DCS\Mods\aircraft\B-21 RAIDER
   ```
3. **Build the EFM DLL (Required — `bin/` is empty by default):**
   - **Visual Studio (x64 Native Tools Prompt):**
     ```bat
     ExternalFM\build_msvc.bat
     ```
   - **MinGW-w64:**
     ```bash
     ExternalFM/build_mingw.sh
     ```
   - **CMake:**
     ```powershell
     cmake -S ExternalFM -B build -A x64 && cmake --build build --config Release
     ```
   - Output binary: `bin\B21_EFM.dll`

## Project Structure

- `ExternalFM/B21_EFM/B21_Aerodata.h` — Aerodynamic tables ($M \times \alpha$) and reference geometry ($300\text{ m}^2$ wing area).
- `ExternalFM/B21_EFM/B21_EFM.cpp` — C++ External Flight Model (FBW, dual engines, fuel system, landing gear, weapons bay, lights, and animation arguments).
- `entry.lua` / `B-21.lua` / `Entry/Suspension.lua` / `Views.lua` — DCS module declaration, suspension physics, and cockpit/external camera views.
- `Cockpit/Scripts/command_defs.lua` — Cockpit command IDs (`10001`–`10020`, synced with `Cmd::` in `.cpp`).
- `Input/B-21/...` — Rebindable keyboard and HOTAS controls in the DCS controls menu.
- `Sounds/...` — Dual-engine sounder and synthetic engine audio.

## Changelog

### Version 0.2.0-alpha

#### Added
- External Flight Model (EFM) in C++ with Fly-By-Wire (FBW), dual-engine propulsion, fuel management, landing gear, weapons bay, and lighting arguments.
- Base 3D external model adapted from [FlightSim.to](https://flightsim.to/addon/46567/northrop-grumman-b-21-raider).
- Custom input bindings and dual-engine sound configuration.

#### TODO / Flight Tuning
- Verify elevon animation signs (`Arg::AILERON_SIGN` / `ELEVATOR_SIGN` in `.cpp`).
- Tune stick authority (`kPitchAuthority` / `kRollAuthority`).
- Refine parametric aerodynamic coefficients (`[N3]` in `B21_Aerodata.h`).
- Expand cockpit scripts and animated instruments (`mainpanel_init.lua` / `Cockpit_B-21.edm`).
- Add `ImagesGUI/B-21.png` menu artwork.