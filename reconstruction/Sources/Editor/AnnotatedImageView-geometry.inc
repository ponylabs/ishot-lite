- (CGPoint)getNewPointForSqureOrEllipse:(CGPoint)p { // 0x10006f07c; table 0x1001a9210/238 decoded to CFStrings
    if (!(IShotGlobal_1001de070 & 1) && IShotGlobal_1001de068 == 2) return p;
    NSString *xkey, *ykey;
    if (IShotGlobal_1001de068 == 0) { xkey=@"X1"; ykey=@"Y1"; }
    else if (IShotGlobal_1001de070-1 < 5) {
        NSString *xs[] = {@"X2",@"X2",@"X1",@"X2",@"X1"};
        NSString *ys[] = {@"Y2",@"Y1",@"Y2",@"Y1",@"Y1"};
        xkey=xs[IShotGlobal_1001de070-1]; ykey=ys[IShotGlobal_1001de070-1];
    } else { xkey=@"X2"; ykey=@"Y1"; }
    float x=[IShotGlobal_1001de058[xkey] floatValue], y=[IShotGlobal_1001de058[ykey] floatValue];
    double dx=fabs(p.x-x),dy=fabs(p.y-y);
    float distance=(float)(dx<dy ? dx:dy);
    return CGPointMake((float)(x+(p.x>x ? distance:-distance)),(float)(y+(p.y>y ? distance:-distance)));
}
- (CGPoint)getNewPointForArrowOrLine:(CGPoint)p { // 0x10006f1b8; float subtraction, double norm, float length and final coordinates
    BOOL first=IShotGlobal_1001de068==0 || IShotGlobal_1001de070==2;
    float x=[IShotGlobal_1001de058[first?@"X1":@"X2"] floatValue], y=[IShotGlobal_1001de058[first?@"Y1":@"Y2"] floatValue];
    double angle=atan2(p.y-y,p.x-x);
    if (angle<0) angle+=6.283185307179586;
    double snapped=angle;
    for (int i=0;i!=50;i+=2) {
        double candidate=((double)i*3.141592653589793)/24.0;
        if (fabs(angle-candidate)<0.1308996938995747) {snapped=candidate;break;}
    }
    double dx=(float)p.x-x,dy=(float)p.y-y;
    double length=(float)sqrt(dx*dx+dy*dy);
    return CGPointMake((float)(cos(snapped)*length+x),(float)(sin(snapped)*length+y));
}
- (NSMutableArray *)_calculateAllNeededHandleSquareRects:(CGRect)r { // 0x10006eb0c; original index0 has zero size and index13 duplicates index12
    NSMutableArray *rects=NSMutableArray.new;
    float halfWidth=(float)r.size.width*0.5f,halfHeight=(float)r.size.height*0.5f;
    double left=r.origin.x-5,bottom=r.origin.y-5;
    double midX=r.origin.x+halfWidth,midY=r.origin.y+halfHeight;
    double right=r.origin.x+(float)r.size.width-5,top=r.origin.y+(float)r.size.height-5;
    double innerX=r.origin.x+5+1,innerY=r.origin.y+5+1;
    CGRect base[]={CGRectMake(innerX,innerY,0,0),CGRectMake(left,bottom,10,10),CGRectMake(midX-5,bottom,10,10),CGRectMake(right,bottom,10,10),CGRectMake(right,midY-5,10,10),CGRectMake(right,top,10,10),CGRectMake(midX-5,top,10,10),CGRectMake(left,top,10,10),CGRectMake(left,midY-5,10,10)};
    for (int i=0;i<9;++i) [rects addObject:[NSValue valueWithCGRect:base[i]]];
    if ([IShotGlobal_1001de058[@"type"] intValue]==8) {
        double w=(float)(halfWidth-10.0f-2.0f),h=(float)(halfHeight-10.0f-2.0f);
        double ix=midX+5+1,iy=midY+5+1;
        CGRect edges[]={CGRectMake(innerX,bottom,w,10),CGRectMake(ix,bottom,w,10),CGRectMake(right,innerY,10,h),CGRectMake(right,iy,10,h),CGRectMake(right,iy,10,h),CGRectMake(innerX,top,w,10),CGRectMake(ix,top,w,10),CGRectMake(left,innerY,10,h),CGRectMake(left,iy,10,h)};
        for (int i=0;i<9;++i) [rects addObject:[NSValue valueWithCGRect:edges[i]]];
    }
    return rects;
}
- (CGRect)getNewRectOfResizeAllStroke { // 0x10006e704
    float x1=[IShotGlobal_1001de058[@"X1"] floatValue],y1=[IShotGlobal_1001de058[@"Y1"] floatValue];
    float x2=[IShotGlobal_1001de058[@"X2"] floatValue],y2=[IShotGlobal_1001de058[@"Y2"] floatValue];
    uint32_t type=[IShotGlobal_1001de058[@"type"] intValue];
    if (IShotGlobal_1001de058[@"moveToX"]) {
        float dx=[IShotGlobal_1001de058[@"moveToX"] floatValue]-[IShotGlobal_1001de058[@"moveX"] floatValue];
        float dy=[IShotGlobal_1001de058[@"moveToY"] floatValue]-[IShotGlobal_1001de058[@"moveY"] floatValue];
        if (type<=8 && ((1U<<type)&0x123)) {
            switch (IShotGlobal_1001de070) {
                case 1:x1+=dx; y1+=dy;break;
                case 2:y1+=dy;break;
                case 3:x2+=dx;y1+=dy;break;
                case 4:x2+=dx;break;
                case 5:x2+=dx;y2+=dy;break;
                case 6:y2+=dy;break;
                case 7:x1+=dx;y2+=dy;break;
                case 8:x1+=dx;break;
            }
        } else if ((type & ~1U)==2) {
            if (IShotGlobal_1001de070==2) {x2+=dx;y2+=dy;}
            else if (IShotGlobal_1001de070==1) {x1+=dx;y1+=dy;}
        }
    }
    if (type==5) {
        if (x1<self.frame.origin.x) x1=self.frame.origin.x;
        if (x2<self.frame.origin.x) x2=self.frame.origin.x;
        if (y1<self.frame.origin.y) y1=self.frame.origin.y;
        if (y2<self.frame.origin.y) y2=self.frame.origin.y;
        if (self.frame.origin.x+self.frame.size.width<x1) x1=self.frame.origin.x+self.frame.size.width;
        if (self.frame.origin.x+self.frame.size.width<x2) x2=self.frame.origin.x+self.frame.size.width;
        if (self.frame.origin.y+self.frame.size.height<y1) y1=self.frame.origin.y+self.frame.size.height;
        if (self.frame.origin.y+self.frame.size.height<y2) y2=self.frame.origin.y+self.frame.size.height;
    }
    float minX=x1,maxX=x2,minY=y1,maxY=y2;
    if (x1>x2) {minX=x2;maxX=x1;} if (y1>y2) {minY=y2;maxY=y1;}
    return CGRectMake(minX,minY,(float)(maxX-minX),(float)(maxY-minY));
}
