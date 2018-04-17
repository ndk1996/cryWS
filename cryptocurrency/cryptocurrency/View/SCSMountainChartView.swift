//
//  SCSStackedMountainChartView.swift
//  cryptocurrency
//
//  Created by Khoa Nguyen on 4/6/18.
//  Copyright © 2018 KhoaNguyen. All rights reserved.
//

import UIKit
import SciChart

class SCSMountainChartView: UIView {

    let surface = SCIChartSurface()
    var dates = [Date]()
    var yValues = Array<Double>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //completeConfiguration()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        completeConfiguration()
    }
    
    func addDefaultModifiers() {
        
        let xAxisDragmodifier = SCIXAxisDragModifier()
        xAxisDragmodifier.dragMode = .scale
        xAxisDragmodifier.clipModeX = .none
        
        let yAxisDragmodifier = SCIYAxisDragModifier()
        yAxisDragmodifier.dragMode = .pan
        
        let extendZoomModifier = SCIZoomExtentsModifier()
        
        let pinchZoomModifier = SCIPinchZoomModifier()
        
        let customOrangeColor = UIColor(red: 226.0 / 255.0, green: 70.0 / 255.0, blue: 12.0 / 255.0, alpha: 1.0)
        let rolloverModifier = SCIRolloverModifier()
        rolloverModifier.style.tooltipSize = CGSize(width: 200, height: CGFloat.nan)
        rolloverModifier.style.tooltipColor = UIColor.orange
        rolloverModifier.style.colorMode = .default
        rolloverModifier.style.tooltipColor = customOrangeColor
        rolloverModifier.style.tooltipOpacity = 0.8
        
        let groupModifier = SCIChartModifierCollection(childModifiers: [xAxisDragmodifier, yAxisDragmodifier, pinchZoomModifier, extendZoomModifier, rolloverModifier])
   
        surface.chartModifiers = groupModifier
    }
    
    // MARK: initialize surface
    fileprivate func addSurface() {
        surface.translatesAutoresizingMaskIntoConstraints = true
        surface.frame = bounds
        surface.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(surface)
    }
    
    // MARK: Overrided Functions
    
    func completeConfiguration() {
        addSurface()
        addAxis()
        addDefaultModifiers()
        addDataSeries()
    }
    
    // MARK: Private Methods
    
    fileprivate func addAxis() {
        surface.xAxes.add(SCIDateTimeAxis())
        surface.yAxes.add(SCINumericAxis())
    }
    
    fileprivate func addDataSeries() {
        
        let mountainDataSeries = SCIXyDataSeries(xType:.dateTime, yType:.double)
        mountainDataSeries.seriesName = "Price"

        mountainDataSeries.acceptUnsortedData = true
        
//        dates.append(Date(timeIntervalSince1970: 1523375669))
//        dates.append(Date(timeIntervalSince1970: 1523260467))
//        dates.append(Date(timeIntervalSince1970: 1523192064))
//        dates.append(Date(timeIntervalSince1970: 1523120067))
//        dates.append(Date(timeIntervalSince1970: 1522976067))
//        dates.append(Date(timeIntervalSince1970: 1522918464))
//        dates.append(Date(timeIntervalSince1970: 1522824868))
//        dates.append(Date(timeIntervalSince1970: 1522785267))
//
//        yValues = [ 1042.0, 345.0, 687.0, 123.0, 1243.0, 891.0, 476.0, 761.0]
        
        
        for i in 0..<yValues.count{
            mountainDataSeries.appendX(SCIGeneric(dates[i]), y:SCIGeneric(yValues[i]));
        }

        let brush = SCILinearGradientBrushStyle(colorCodeStart: 0xAAFF8D42, finish: 0x88090E11, direction: .vertical)
        let renderableSeroiesTop = createRenderableSeriesWith(brush, pen: SCISolidPenStyle(colorCode: 0xAAFFC9A8, withThickness: 1.0), dataSeries: mountainDataSeries)
        
        let stackedGroup = SCIVerticallyStackedMountainsCollection()
        stackedGroup.add(renderableSeroiesTop)
        
        let animation = SCIWaveRenderableSeriesAnimation(duration: 3, curveAnimation: .easeOut)
        animation.start(afterDelay: 0.3)
        stackedGroup.addAnimation(animation)
        
        surface.renderableSeries.add(stackedGroup)
        
    }
    
    fileprivate func createRenderableSeriesWith(_ brush: SCILinearGradientBrushStyle, pen: SCISolidPenStyle, dataSeries: SCIXyDataSeries) ->  SCIStackedMountainRenderableSeries {
        
        let renderableSeries = SCIStackedMountainRenderableSeries()
        renderableSeries.areaStyle = brush
        renderableSeries.style.strokeStyle = pen
        renderableSeries.dataSeries = dataSeries
        
        return renderableSeries;
    }
    
    fileprivate func fillDataInto(_ dataSeries: SCIXyDataSeries) {
        //SCSDataManager.loadData(into: dataSeries,fileName: "FinanceData",startIndex: 1,increment: 1,reverse: true)
    }
    
    
    
}

