<h1 class="fluid-api-header">
<div class="fluid-header-icon">
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="36" height="36"><path d="M12 1L21.5 6.5V17.5L12 23L2.5 17.5V6.5L12 1ZM6.49896 9.97089L11 12.5768V17.6252H13V12.5768L17.501 9.9709L16.499 8.24005L12 10.8447L7.50104 8.24004L6.49896 9.97089Z" fill="rgba(255,255,255,1)"></path></svg>
</div>

<span class="fluid-header-title">base</span>

<div class="fluid-header-pills">
<span class="fluid-header-pill private">private</span>
</div>
</h1>

An extendable class that has methods used by all variations of the `tween` class.

```lua
(targets: tweenTargets, info: normalTweenInfo|serverTweenInfo, properties: properties) -> baseTween
```

<hr>

### Parameters

#### targets
The targets to animate. This can be a single instance or an array of instances.

#### info
The tween info.

#### properties
The properties to animate and their corresponding target values and info.

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
