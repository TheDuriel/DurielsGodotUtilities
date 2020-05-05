# DurielsGodotUtilities
A collection of useful Scripts, Scenes, Systems, and Templates for the Godot Game Engine.

All content is MIT.

Like the content? Follow me on Twitter https://twitter.com/the_duriel or support my Patreon https://www.patreon.com/TheDuriel

* `Classes/`, Standalone Classes of various nature.
* `UIComponents/`, Individual Control classes or entire Scenes.
* `UtilityAI-Static/`, the Core components of a Utility based AI model.
* `VR/` VR specific Classes and Scenes.
* `addons/` Editor Plugins.
* `addonsbasic/` More complex systems which use class_name to add themselves to your editor.
* `outdated/` Code examples and older work which may no longer function.

Some highlights:

`.gitignore` and `.gitattributes` covering many standard file formats and conventions relating to Godot.

`addons/DurielEditorTools` adds some minor, yet useful enhancements, to the Editor. Including enhanced performance when running your game, (by switching to the script view, and optionally preventing the editor from rendering in the background), and setting a fixed minimum size to all Docks. It also hides the Asset library button.

`addonsbasic/AutoAstar2D` is an Astar2D wrapper which allows you to visually build A* grids from within the editor. The grid can be updated in _real time_, even during gameplay. https://twitter.com/the_duriel/status/1248239309116899328

`addonsbasic/StateMachine` is a fully code based StateMachine implementation. Including Master state, State Switching, Entry and Exit events, ~~and Pushdown Automata.~~

`addonsbasic/UserOptions` is a Singleton which abstracts saving and loading user options from a .cfg file, boiling it all down to single function calls. It also autosaves the settings.

`addonsbasic/VRUI` is a UI in 3D implementation which allows interaction through mouse, and a virtual mouse pointer (raycast) for VR usage.
