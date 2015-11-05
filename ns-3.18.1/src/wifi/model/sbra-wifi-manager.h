#ifndef SBRA_WIFI_MANAGER_H
#define SBRA_WIFI_MANAGER_H

#include "ns3/mac48-address.h"
#include <stdint.h>
#include <vector>
#include "wifi-mode.h"
#include "wifi-remote-station-manager.h"
#include "fb-headers.h"

namespace ns3 {

typedef struct{
	Mac48Address addr;
 	struct rxInfo info;	
}StaInfo;

class SbraWifiManager : public WifiRemoteStationManager
{
public:
  static TypeId GetTypeId (void);
  SbraWifiManager ();
  virtual ~SbraWifiManager ();
	
  void UpdateInfo(Mac48Address addr, struct rxInfo info);
	
  virtual void SetupPhy (Ptr<WifiPhy> phy);
	virtual void GroupRateAdaptation (void);

private:
  // overriden from base class
  virtual WifiRemoteStation* DoCreateStation (void) const;
 	// jychoi
	virtual WifiMode DoGroupRateAdaptation (void);

	virtual void DoReportRxOk (WifiRemoteStation *station,
                             double rxSnr, WifiMode txMode);
  virtual void DoReportRtsFailed (WifiRemoteStation *station);
  virtual void DoReportDataFailed (WifiRemoteStation *station);
  virtual void DoReportRtsOk (WifiRemoteStation *station,
                              double ctsSnr, WifiMode ctsMode, double rtsSnr);
  virtual void DoReportDataOk (WifiRemoteStation *station,
                               double ackSnr, WifiMode ackMode, double dataSnr);
  virtual void DoReportFinalRtsFailed (WifiRemoteStation *station);
  virtual void DoReportFinalDataFailed (WifiRemoteStation *station);
  virtual WifiTxVector DoGetDataTxVector (WifiRemoteStation *station, uint32_t size);
  virtual WifiTxVector DoGetRtsTxVector (WifiRemoteStation *station);
  virtual bool IsLowLatency (void) const;

  // return the min snr needed to successfully transmit
  // data with this mode at the specified ber.
  double GetSnrThreshold (WifiMode mode) const;
  void AddModeSnrThreshold (WifiMode mode, double ber);

  typedef std::vector<std::pair<double,WifiMode> > Thresholds;

  Thresholds m_thresholds;
	double m_ber;
	Ptr<WifiPhy> m_phy;
	
	//jychoi
	//void SnrRateAdaptation ();

	typedef std::vector<Mac48Address> macAddress;
	typedef std::vector<double> GroupRxSnr;

	std::vector<StaInfo> m_infos;

	WifiMode m_GroupTxMode;
	macAddress m_macAddress;
	GroupRxSnr m_GroupRxSnr;
	double m_minSnr;
	bool m_initial;
	uint32_t m_type;
	double m_per;
};

} // namespace ns3

#endif /* SBRA_WIFI_MANAGER_H */
