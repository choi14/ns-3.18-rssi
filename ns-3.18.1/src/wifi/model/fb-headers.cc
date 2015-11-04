#include "fb-headers.h"
#include "ns3/log.h"
#include "ns3/simulator.h"

NS_LOG_COMPONENT_DEFINE("FeedbackHeader");

namespace ns3 {
	
NS_OBJECT_ENSURE_REGISTERED(FeedbackHeader);

TypeId
FeedbackHeader::GetTypeId (void)
{
  static TypeId tid = TypeId ("ns3::FeedbackHeader")
    .SetParent<Header> ()
    .AddConstructor<FeedbackHeader> ()
  ;
  return tid;
}

TypeId
FeedbackHeader::GetInstanceTypeId (void) const
{
  return GetTypeId ();
}

void 
FeedbackHeader::Print(std::ostream &os) const
{
	os << "RSSI = " << m_rxRssi << "\n";
}

uint32_t
FeedbackHeader::GetSerializedSize (void) const
{
  return 16;
}
void
FeedbackHeader::Serialize (Buffer::Iterator start) const
{
  start.WriteHtonU32 (m_rxRssi);
  start.WriteHtonU32 (m_rxSnr);
  start.WriteHtonU32 (m_rxPacket);
  start.WriteHtonU32 (m_totalPacket);
}
uint32_t
FeedbackHeader::Deserialize (Buffer::Iterator start)
{
	Buffer::Iterator i = start;
	m_totalPacket = i.ReadNtohU32 (); 
	m_rxPacket = i.ReadNtohU32 (); 
	m_rxRssi = i.ReadNtohU32 (); 
	m_rxSnr = i.ReadNtohU32 (); 
  return i.GetDistanceFrom (start);
}
// jychoi
// Set function
void
FeedbackHeader::SetRssi (uint32_t rxRssi)
{
	m_rxRssi = rxRssi;
}
void
FeedbackHeader::SetSnr (uint32_t rxSnr)
{
	m_rxSnr = rxSnr;
}
void
FeedbackHeader::SetRxPacket (uint32_t rxPacket)
{
	m_rxPacket = rxPacket;
}
void
FeedbackHeader::SetTotalPacket (uint32_t totalPacket)
{
	m_totalPacket = totalPacket;
}
// jychoi
// Get function
uint32_t
FeedbackHeader::GetRssi (void)
{
	return m_rxRssi;
}
uint32_t
FeedbackHeader::GetSnr (void)
{
	return m_rxSnr;
}
uint32_t
FeedbackHeader::GetRxPacket (void)
{
	return m_rxPacket;
}
uint32_t
FeedbackHeader::GetTotalPacket (void)
{
	return m_totalPacket;
}

} // namespace ns3
