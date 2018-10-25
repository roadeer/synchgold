import backtrader as bt
import datetime
from backtrader.commissions.bitmex import BitmexCommInfo


class OpenClose(bt.Indicator):
    lines = ("diff", )

    def __init__(self):
        self.lines.diff = self.data0.close - self.data0.open


class MyStrategy(bt.Strategy):

    def __init__(self):
        self.diff = self.data0.close - self.data0.open
        self.diff_ind = OpenClose()

        # example indicators
        self.ema = bt.indicators.EMA(self.diff_ind)
        self.macd = bt.indicators.MACDHisto(self.diff_ind)
        self.rsi = bt.indicators.RSI(self.diff_ind)
        self.crossover = bt.indicators.CrossOver(self.diff_ind, 0)

    def next(self):
        print("{} open-close={}".format(len(self), self.diff[0]))
        print("{} OpenClose Indicator={}".format(len(self), self.diff_ind[0]))


def run():
    cerebro = bt.Cerebro(stdstats=False, oldbuysell=True)

    base_freq = 240
    leverage = 4
    commission = 0.00075

    # 添加策略
    cerebro.addstrategy(MyStrategy)

    fromdate = datetime.datetime.strptime('2018-09-01 00:00:00', '%Y-%m-%d %H:%M:%S')
    todate = datetime.datetime.strptime('2018-10-23 00:00:00', '%Y-%m-%d %H:%M:%S')

    data = bt.feeds.TimeBars(
        dataname='bitmex_xbtusd',
        fromdate=fromdate,
        todate=todate,
        timeframe=bt.TimeFrame.Minutes,
        compression=base_freq
    )
    cerebro.adddata(data)

    cerebro.broker.setcash(10)

    comminfo = BitmexCommInfo(
        leverage=leverage,
        commission=commission
    )
    cerebro.broker.addcommissioninfo(comminfo)
    cerebro.broker.set_shortcash(False)

    cerebro.addanalyzer(bt.analyzers.SQN)
    cerebro.addobserver(bt.observers.DrawDown)

    # 运行策略
    cerebro.run()

    cerebro.output_results(__file__)

    # 打印图表
    cerebro.plot(
        style='candle',
        volume=True,
        numfigs=1,
        rowsmajor=1,
        rowsminor=1,
        hlinescolor='red',
        hlineswidth=1,
    )


if __name__ == "__main__":
    run()

