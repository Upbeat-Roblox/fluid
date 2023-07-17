<h1 class="fluid-api-header">
<div class="fluid-header-icon">
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="36" height="36"><path d="M4 18V14.3C4 13.4716 3.32843 12.8 2.5 12.8H2V11.2H2.5C3.32843 11.2 4 10.5284 4 9.7V6C4 4.34315 5.34315 3 7 3H8V5H7C6.44772 5 6 5.44772 6 6V10.1C6 10.9858 5.42408 11.7372 4.62623 12C5.42408 12.2628 6 13.0142 6 13.9V18C6 18.5523 6.44772 19 7 19H8V21H7C5.34315 21 4 19.6569 4 18ZM20 14.3V18C20 19.6569 18.6569 21 17 21H16V19H17C17.5523 19 18 18.5523 18 18V13.9C18 13.0142 18.5759 12.2628 19.3738 12C18.5759 11.7372 18 10.9858 18 10.1V6C18 5.44772 17.5523 5 17 5H16V3H17C18.6569 3 20 4.34315 20 6V9.7C20 10.5284 20.6716 11.2 21.5 11.2H22V12.8H21.5C20.6716 12.8 20 13.4716 20 14.3Z" fill="rgba(255,255,255,1)"></path></svg>
</div>

<span class="fluid-header-title">bareboneTween</span>

<div class="fluid-header-pills">
<span class="fluid-header-pill private">private</span>
</div>
</h1>

The `bareboneTween` class represents a basic tween object without the update methods or the start, stop, and scrub methods.

```lua
(targets: targets, info: info, properties: properties) -> bareboneTween
```

<hr>

### Parameters

- `targets: targets` - The targets to animate. This can be a single instance or an array of instances.
- `info: info` - The tween info.
- `properties: properties` - The properties to animate and their corresponding target values and info.

<hr>

### Events

#### `completed`
Fired when the tween animation completes.

#### `stopped`
Fired when the tween animation is stopped.

#### `stateChanged`
Fired when the state of the tween animation changes.

**Returns**: The new state of the tween animation (`Enum.PlaybackState`).

#### `resumed`
Fired when the tween animation is resumed after being paused.



<hr>

### Methods

#### `destroy()`
Destroys the tween animation and stops it if it is playing.

#### `Destroy()`
An alias for the `destroy()` method.
