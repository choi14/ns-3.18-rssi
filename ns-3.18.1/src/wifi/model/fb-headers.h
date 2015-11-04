#ifndef FB_HEADERS_H
#define FB_HEADERS_H

//#include <stdint.h>

#include "ns3/header.h"

namespace ns3 {

struct rxInfo
{
	uint32_t Rssi;
	uint32_t Snr;
	uint32_t LossPacket;
	uint32_t TotalPacket;
};

class FeedbackHeader : public Header
{
public:
	static TypeId GetTypeId (void);
	virtual TypeId GetInstanceTypeId (void) const;
	virtual void Print (std::ostream &os) const;
  virtual uint32_t GetSerializedSize (void) const;
  virtual void Serialize (Buffer::Iterator start) const;
  virtual uint32_t Deserialize (Buffer::Iterator start);

	void SetRssi (uint32_t rxRssi);
	void SetSnr (uint32_t rxSnr);
	void SetRxPacket (uint32_t rxPacket);
	void SetTotalPacket (uint32_t totalPacket);

	uint32_t GetRssi (void);
	uint32_t GetSnr (void);
	uint32_t GetRxPacket (void);
	uint32_t GetTotalPacket (void);

private:
	uint32_t m_rxRssi;
	uint32_t m_rxSnr;
	uint32_t m_rxPacket;
	uint32_t m_totalPacket;

};

} // namespace ns3

#endif /* FB_HEADERS_H */
