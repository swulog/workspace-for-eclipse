//
//  GeometryImg.h
//  BossE_V1
//
//  Created by 万松 on 12-10-14.
//
//

#import <UIKit/UIKit.h>

typedef enum {
    Geometry_Line,
    Geometry_DotLine,
    Geometry_Ellipse
}GeometryType;

@interface GeometryImg : UIView

@property(nonatomic,assign)GeometryType type;

@property(nonatomic,strong)UIColor *fillColor;
@property(nonatomic,strong)UIColor *lineColor;
@property(nonatomic,assign)NSInteger lineWidth;
@property(nonatomic,assign) BOOL isVertical;
@end
