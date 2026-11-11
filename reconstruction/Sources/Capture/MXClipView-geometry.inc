- (CGRect)getNewRectByReSize:(CGPoint)point resizeposition:(int)position { // 0x100031860
    double x1=point.x,y1=point.y,x2=0,y2=0;
    switch (position) {
        case 1: x2=IShotMXEndX(self.lastContentRectBeforeResize); y2=IShotMXEndY(self.lastContentRectBeforeResize); break;
        case 2: x1=self.lastContentRectBeforeResize.origin.x; x2=IShotMXEndX(self.lastContentRectBeforeResize); y2=IShotMXEndY(self.lastContentRectBeforeResize); break;
        case 3: x1=self.lastContentRectBeforeResize.origin.x; y2=IShotMXEndY(self.lastContentRectBeforeResize); x2=point.x; break;
        case 4: x1=self.lastContentRectBeforeResize.origin.x; y1=self.lastContentRectBeforeResize.origin.y; y2=IShotMXEndY(self.lastContentRectBeforeResize); x2=point.x; break;
        case 5: x1=self.lastContentRectBeforeResize.origin.x; y1=self.lastContentRectBeforeResize.origin.y; x2=point.x; y2=point.y; break;
        case 6: x1=self.lastContentRectBeforeResize.origin.x; y1=self.lastContentRectBeforeResize.origin.y; x2=IShotMXEndX(self.lastContentRectBeforeResize); y2=point.y; break;
        case 7: y1=self.lastContentRectBeforeResize.origin.y; x2=IShotMXEndX(self.lastContentRectBeforeResize); y2=point.y; break;
        case 8: y1=self.lastContentRectBeforeResize.origin.y; x2=IShotMXEndX(self.lastContentRectBeforeResize); y2=IShotMXEndY(self.lastContentRectBeforeResize); break;
        default: x1=y1=0; break;
    }
    int a=(int)x1,b=(int)y1,c=(int)x2,d=(int)y2;
    if (a<0) a=0; if (b<0) b=0;
    if (IShotGlobal_1001dde80.frame.size.width<(double)a) a=(int)IShotGlobal_1001dde80.frame.size.width;
    if (IShotGlobal_1001dde80.frame.size.height<(double)b) b=(int)IShotGlobal_1001dde80.frame.size.height;
    if (c<0) c=0; if (d<0) d=0;
    if (IShotGlobal_1001dde80.frame.size.width<(double)c) c=(int)IShotGlobal_1001dde80.frame.size.width;
    if (IShotGlobal_1001dde80.frame.size.height<(double)d) d=(int)IShotGlobal_1001dde80.frame.size.height;
    int width=(int)((uint32_t)c-(uint32_t)a), height=(int)((uint32_t)d-(uint32_t)b);
    return CGRectMake(c>a?a:c,d>b?b:d,width<0?(int)(0U-(uint32_t)width):width,height<0?(int)(0U-(uint32_t)height):height);
}
- (id)_calculateAllNeededHandleSquareRects:(CGRect)rect { // 0x100033200
    NSMutableArray *result=[NSMutableArray new];
    double x=rect.origin.x,y=rect.origin.y;
    float width=(float)rect.size.width,height=(float)rect.size.height;
    float halfWidth=width*.5f,halfHeight=height*.5f;
    double innerX=x+5+1,innerY=y+5+1,left=x-5,bottom=y-5;
    double midX=x+(double)halfWidth,midY=y+(double)halfHeight;
    double right=x+(double)width-5,top=y+(double)height-5;
    [result addObject:[NSValue valueWithCGRect:CGRectMake(innerX,innerY,0,0)]];
    [result addObject:[NSValue valueWithCGRect:CGRectMake(left,bottom,10,10)]];
    [result addObject:[NSValue valueWithCGRect:CGRectMake(midX-5,bottom,10,10)]];
    [result addObject:[NSValue valueWithCGRect:CGRectMake(right,bottom,10,10)]];
    [result addObject:[NSValue valueWithCGRect:CGRectMake(right,midY-5,10,10)]];
    [result addObject:[NSValue valueWithCGRect:CGRectMake(right,top,10,10)]];
    [result addObject:[NSValue valueWithCGRect:CGRectMake(midX-5,top,10,10)]];
    [result addObject:[NSValue valueWithCGRect:CGRectMake(left,top,10,10)]];
    [result addObject:[NSValue valueWithCGRect:CGRectMake(left,midY-5,10,10)]];
    int type=[IShotGlobal_1001de058[@"type"] intValue];
    if (type==8 || type==5) {
        double horizontal=(double)(halfWidth-10.f-2.f),vertical=(double)(halfHeight-10.f-2.f);
        double secondX=midX+5+1,secondY=midY+5+1;
        [result addObject:[NSValue valueWithCGRect:CGRectMake(innerX,bottom,horizontal,10)]];
        [result addObject:[NSValue valueWithCGRect:CGRectMake(secondX,bottom,horizontal,10)]];
        [result addObject:[NSValue valueWithCGRect:CGRectMake(right,innerY,10,vertical)]];
        [result addObject:[NSValue valueWithCGRect:CGRectMake(right,secondY,10,vertical)]];
        [result addObject:[NSValue valueWithCGRect:CGRectMake(right,secondY,10,vertical)]];
        [result addObject:[NSValue valueWithCGRect:CGRectMake(innerX,top,horizontal,10)]];
        [result addObject:[NSValue valueWithCGRect:CGRectMake(secondX,top,horizontal,10)]];
        [result addObject:[NSValue valueWithCGRect:CGRectMake(left,innerY,10,vertical)]];
        [result addObject:[NSValue valueWithCGRect:CGRectMake(left,secondY,10,vertical)]];
    }
    return result;
}
- (CGPoint)getPositionOfDragging:(CGPoint)point { // 0x10003377c; all branches checked against arm64
    CGRect screen=IShotGlobal_1001dde80.frame;
    int mouseX=(int)(point.x-screen.origin.x);
    double converted=screen.origin.y+(point.y+screen.size.height);
    int mouseY=(int)(screen.size.height-(converted-NSScreen.deepestScreen.frame.size.height));
    int x=mouseX-130,y=mouseY+10;
    CGRect rect=self.contentRect;
    double left=rect.origin.x,bottom=rect.origin.y,width=rect.size.width,height=rect.size.height;
    int resize=self.cropBorderView.numberOfReSize;
    if (!self.onlyClipCurrentWindow) {
        int screenWidth=(int)screen.size.width,screenHeight=(int)screen.size.height;
        if (resize==0 || (resize&1)) {
            if (left+width*.5<(double)(mouseX-10) && !(bottom+height*.5<=(double)y)) {
                int outside=(int)(left+width+10),inside=(int)(left+width-120-10);
                int above=(int)(bottom+10),below=(int)(bottom-120-10);
                if (below<0) below=above;
                if (outside+120<=screenWidth) { x=outside; y=above; }
                else { x=inside; y=below; }
            }
            if (y+120>screenHeight) {
                int toRight=mouseX+10;
                if (mouseX+130>screenWidth) toRight=(int)(left+width-120-10);
                int toLeft=x<0?(int)(left+10):x;
                y=(int)(bottom+height-120-10);
                x=left<=(double)x?toRight:toLeft;
            } else if (x>=0) {
                if (x+120<=screenWidth) { if (y<0) y=0; }
                else x=screenWidth-120;
            } else if (bottom+height<=(double)y) {
                if (y+120<screenHeight) x=(int)(left+10+self.indicatorField.frame.size.width);
                else { x=(int)(left+10); y=(int)(bottom+height-120-10); }
            } else {
                x=(int)(left+10); y=(int)(bottom-120-10); if (y<0) y=(int)(bottom+10);
            }
        } else if ((resize&~4U)==2) {
            if (bottom<=(double)(mouseY-20)) {
                int above=(int)(bottom+height+10);
                y=above+120<=screenHeight?above:(int)(bottom+height-120-10);
            } else { y=(int)(bottom-120-10); if (y<0) y=(int)(bottom+10); }
        } else if (resize==8 || resize==4) {
            int right=(int)(left+width+10);
            if (right+120>screenWidth) right=(int)(left+width-120-10);
            int leftSide=(int)(left-120-10); if (leftSide<0) leftSide=(int)(left+10);
            x=left<=(double)(mouseX-20)?right:leftSide;
        }
    }
    if (x<0) x=0; return CGPointMake(x,y);
}
