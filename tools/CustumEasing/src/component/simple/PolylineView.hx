package component.simple;
import api.react.React;
import api.react.ReactComponent;
import api.react.ReactComponent.ReactComponentOfProps;
import component.basic.GraphColor;
import component.basic.GraphView;
import component.basic.NumberInputView;
import component.complex.ComplexEasingId;
import core.RootCommand;
import core.RootContext;
import core.easing.EasingCommand;
import tweenxcore.expr.ComplexEasingKind;
import tweenxcore.expr.LineKind;
import tweenxcore.expr.LineKindTools;
import tweenxcore.expr.SimpleEasingKind;
import tweenxcore.expr.SimpleEasingKindTools;
import tweenxcore.geom.Point;

class PolylineView extends ReactComponentOfProps<PolylineProps>
{
    public function new(props:PolylineProps) 
    {
        super(props);
    }
    
    override public function render():ReactComponent
    {
        var lines = [
            { easing: LineKindTools.toFunction(props.polyline, props.controls), color: GraphColor.Theme }
        ];
        
        if (!props.polyline.match(LineKind.Polyline))
        {
            lines.unshift(
                { easing: LineKindTools.toFunction(LineKind.Polyline, props.controls), color: GraphColor.Sub }
            );
        }
        
        return React.createElement(
            "div",
            {
                className: "param-group"
            }, 
            [
                for (i in 0...props.controls.length)
                {
                    "div".createElement(
                        {
                            className: "control-point"
                        },
                        [
                            "div".createElement(
                                {},
                                NumberInputView.createElement(
                                    {
                                        name: Std.string(i),
                                        value: props.controls[i],
                                        id: props.id.numberInputId(i),
                                        context: props.context
                                    }
                                )
                            ),
                            "button".createElement(
                                {
                                    className: "btn btn-primary btn-sm",
                                    onClick: add.bind(i),
                                },
                                "span".createElement(
                                    { className: "glyphicon glyphicon-plus" }
                                )
                            ),
                            if (0 < i && i < props.controls.length - 1)
                            {
                                "button".createElement(
                                    {
                                        className: "btn btn-primary btn-sm",
                                        onClick: remove.bind(i),
                                    },
                                    "span".createElement(
                                        { className: "glyphicon glyphicon-minus" }
                                    )
                                );
                            } else null,
                        ]
                    );
                }
            ],
            GraphView.createElement(
                {
                    lines: lines,
                    partations: [],
                    scale: 0.45,
                }
            )
        );
    }
    
    private function add(index:Int):Void
    {
        apply(EasingCommand.AddRate(index));
    }
    
    private function remove(index:Int):Void
    {
        apply(EasingCommand.RemoveRate(index));
    }
    
    private function apply(command:EasingCommand):Void
    {
        props.context.apply(RootCommand.ChangeEasing(props.id, command), true);
    }
}

typedef PolylineProps = 
{
    polyline: LineKind,
    controls: Array<Float>,
    id: ComplexEasingId,
    context: RootContext
}
