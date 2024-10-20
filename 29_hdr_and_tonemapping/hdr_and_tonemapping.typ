#set page(fill: rgb(35, 35, 38, 255), height: auto, paper: "a3")
#set text(fill: color.hsv(0deg, 0%, 90%, 100%), size: 22pt, font: "Microsoft YaHei")
#set raw(theme: "themes/Material-Theme.tmTheme")

= 1. HDR
HDR（高动态范围）指的是游戏引擎处理非常明亮的光或颜色的能力。Bevy 的渲染器内部是 HDR 的，这意味着你可以拥有颜色超过 1.0 的对象、非常明亮的光源或明亮的自发光材料。

这与 HDR 显示输出不同，后者是指能够生成 HDR 图像并在具有 HDR 功能的现代显示器或电视上显示。Bevy 目前还不支持这一点。

内部 HDR 图像必须在显示到屏幕上之前转换为 SDR（标准动态范围）。这个过程称为色调映射。Bevy 支持不同的算法，可以产生不同的效果。选择哪种色调映射算法是一个艺术选择。

= 2. 相机 HDR 配置
每个相机都有一个切换开关，让你决定是否希望 Bevy 内部保留 HDR 数据，以便后续的渲染过程（如后处理效果）可以使用它。
```rs
commands.spawn((
    Camera3dBundle {
        camera: Camera {
            hdr: true,
            ..default()
        },
        ..default()
    },
));
```

如果启用，Bevy 的中间纹理将采用 HDR 格式。着色器输出 HDR 值，Bevy 将存储它们，以便在后续渲染过程中使用。这允许你启用像 Bloom 这样的效果，这些效果利用 HDR 数据。色调映射将在 HDR 数据不再需要之后作为后期处理步骤进行。

如果禁用，着色器预计输出 0.0 到 1.0 范围内的标准 RGB 颜色。色调映射在着色器中进行。HDR 信息不会被保留。需要 HDR 数据的效果（如 Bloom）将无法工作。

默认情况下是禁用的，因为这对于不需要复杂图形的应用程序来说，性能更好且减少了显存使用。

= 3. 色调映射
色调映射是渲染过程中将像素颜色从引擎中的中间表示转换为最终显示在屏幕上的值的步骤。

这对于 HDR 应用程序非常重要，因为在这种情况下，图像可能包含非常亮的像素（超过 1.0），需要重新映射到可以显示的范围内。

Bevy 支持多种不同的色调映射算法。每种算法都会产生不同的效果，影响颜色和亮度。这可以是一个艺术选择。你可以决定哪种算法最适合你的游戏。Bevy 的默认算法是 TonyMcMapface，尽管名字有点搞笑，但它为各种图形风格提供了非常好的效果。

一些色调映射算法（包括默认的 TonyMcMapface）需要 tonemapping_luts cargo feature。默认情况下启用。如果你禁用了默认特性并且需要它，请确保重新启用它。